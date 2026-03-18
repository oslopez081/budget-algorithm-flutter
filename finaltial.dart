import React, { useState, useMemo } from 'react';
import { PlusCircle, AlertCircle, CheckCircle2, Trash2, Calculator, Wallet, CreditCard, Activity } from 'lucide-react';

export default function App() {
  // State variables (equivalent to your Flutter Controllers and RAM variables)
  const [income, setIncome] = useState('');
  const [fixedExpenses, setFixedExpenses] = useState('');
  const [variableInput, setVariableInput] = useState('');
  const [variableExpensesList, setVariableExpensesList] = useState([]); // List for Iteration
  const [isEmergency, setIsEmergency] = useState(false); // The "Flag" Boolean
  const [displayResult, setDisplayResult] = useState(null);

  // FUNCIÓN PARA AGREGAR GASTOS (Simula el "Add another? = Yes" del Flowchart)
  const addVariableExpense = () => {
    const amount = parseFloat(variableInput);
    if (!isNaN(amount) && amount > 0) {
      setVariableExpensesList([...variableExpensesList, amount]);
      setVariableInput('');
    }
  };

  // ALGORITMO PRINCIPAL (Aquí ocurre la magia de tu Flowchart)
  const calculateBudget = () => {
    // 1. SEQUENCING & INPUTS
    const monthlyIncome = parseFloat(income) || 0.0;
    const fixed = parseFloat(fixedExpenses) || 0.0;
    
    // 2. ITERATION (Bucle para sumar todos los gastos variables agregados)
    let totalVariable = 0;
    for (let i = 0; i < variableExpensesList.length; i++) {
      totalVariable += variableExpensesList[i];
    }

    const totalExpenses = fixed + totalVariable;

    // 3. CALCULATION
    const remainingBudget = monthlyIncome - totalExpenses;

    // 4. SELECTION (Lógica Booleana Optimizada)
    // Traducimos: remainingBudget < 0 AND NOT emergencyFlag
    const isOverBudget = remainingBudget < 0 && !isEmergency;

    setDisplayResult({
      amount: remainingBudget.toFixed(2),
      isWarning: isOverBudget,
      message: isOverBudget 
        ? `CRITICAL WARNING: Budget Exceeded! Deficit: $${Math.abs(remainingBudget).toFixed(2)}`
        : `Success. Remaining Budget: $${remainingBudget.toFixed(2)}`
    });
  };

  const removeExpense = (index) => {
    const newList = [...variableExpensesList];
    newList.splice(index, 1);
    setVariableExpensesList(newList);
  };

  return (
    <div className="min-h-screen bg-slate-50 p-4 md:p-8 font-sans text-slate-900">
      <div className="max-w-md mx-auto bg-white rounded-3xl shadow-xl overflow-hidden border border-slate-100">
        
        {/* Header - Mimicking Flutter AppBar */}
        <div className="bg-blue-600 p-6 text-white shadow-lg">
          <div className="flex items-center gap-3">
            <Wallet className="w-8 h-8" />
            <h1 className="text-2xl font-bold tracking-tight">Finance Tracker</h1>
          </div>
          <p className="text-blue-100 text-sm mt-1 opacity-90">Algorithm-Based Budgeting</p>
        </div>

        <div className="p-6 space-y-6">
          
          {/* Main Inputs */}
          <div className="space-y-4">
            <div className="relative">
              <label className="text-xs font-bold text-slate-500 uppercase ml-1">Monthly Income ($)</label>
              <div className="flex items-center border-b-2 border-slate-200 focus-within:border-blue-500 transition-colors py-2">
                <span className="text-slate-400 mr-2">$</span>
                <input 
                  type="number" 
                  value={income}
                  onChange={(e) => setIncome(e.target.value)}
                  placeholder="0.00"
                  className="w-full focus:outline-none text-lg font-medium"
                />
              </div>
            </div>

            <div className="relative">
              <label className="text-xs font-bold text-slate-500 uppercase ml-1">Fixed Expenses ($)</label>
              <div className="flex items-center border-b-2 border-slate-200 focus-within:border-blue-500 transition-colors py-2">
                <CreditCard className="w-5 h-5 text-slate-400 mr-2" />
                <input 
                  type="number" 
                  value={fixedExpenses}
                  onChange={(e) => setFixedExpenses(e.target.value)}
                  placeholder="Rent, Utilities, etc."
                  className="w-full focus:outline-none text-lg font-medium"
                />
              </div>
            </div>
          </div>

          <hr className="border-slate-100" />

          {/* Variable Expenses Section */}
          <div className="space-y-4">
            <label className="text-xs font-bold text-slate-500 uppercase ml-1">Add Variable Expense</label>
            <div className="flex gap-2">
              <div className="flex-1 flex items-center border-2 border-slate-100 rounded-xl px-3 focus-within:border-blue-200 bg-slate-50 transition-all">
                <Activity className="w-4 h-4 text-slate-400 mr-2" />
                <input 
                  type="number" 
                  value={variableInput}
                  onChange={(e) => setVariableInput(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && addVariableExpense()}
                  placeholder="Groceries, Dining, etc."
                  className="w-full py-2 bg-transparent focus:outline-none text-sm"
                />
              </div>
              <button 
                onClick={addVariableExpense}
                className="bg-green-500 hover:bg-green-600 text-white p-2 rounded-xl shadow-md active:scale-95 transition-all"
              >
                <PlusCircle className="w-6 h-6" />
              </button>
            </div>

            {/* Emergency Flag */}
            <label className="flex items-center gap-3 p-3 bg-slate-50 rounded-xl border border-slate-100 cursor-pointer hover:bg-slate-100 transition-colors">
              <input 
                type="checkbox" 
                checked={isEmergency}
                onChange={(e) => setIsEmergency(e.target.checked)}
                className="w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500 cursor-pointer"
              />
              <span className="text-sm font-medium text-slate-700">Is this an emergency expense?</span>
            </label>

            {/* Variable Expenses List Display */}
            <div className="space-y-2 max-h-40 overflow-y-auto pr-1">
              {variableExpensesList.length === 0 ? (
                <p className="text-xs text-center text-slate-400 italic py-2">No variable expenses added yet.</p>
              ) : (
                variableExpensesList.map((val, idx) => (
                  <div key={idx} className="flex justify-between items-center bg-white border border-slate-100 p-2 rounded-lg text-sm group shadow-sm">
                    <span className="text-slate-600 font-medium">Expense #{idx + 1}</span>
                    <div className="flex items-center gap-3">
                      <span className="font-bold text-slate-800">${val.toFixed(2)}</span>
                      <button onClick={() => removeExpense(idx)} className="text-red-400 hover:text-red-600 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                ))
              )}
            </div>
            <p className="text-[10px] uppercase font-bold text-slate-400 text-center tracking-widest">
              Total Variables: {variableExpensesList.length}
            </p>
          </div>

          {/* Calculate Button */}
          <button 
            onClick={calculateBudget}
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-2xl shadow-lg shadow-blue-200 flex items-center justify-center gap-2 active:scale-[0.98] transition-all"
          >
            <Calculator className="w-5 h-5" />
            CALCULATE BUDGET
          </button>

          {/* Result Output */}
          {displayResult && (
            <div className={`mt-4 p-6 rounded-2xl border-2 animate-in fade-in slide-in-from-bottom-2 duration-300 ${
              displayResult.isWarning 
                ? 'bg-red-50 border-red-200 text-red-700' 
                : 'bg-green-50 border-green-200 text-green-700'
            }`}>
              <div className="flex items-start gap-3">
                {displayResult.isWarning ? (
                  <AlertCircle className="w-6 h-6 mt-1 flex-shrink-0" />
                ) : (
                  <CheckCircle2 className="w-6 h-6 mt-1 flex-shrink-0" />
                )}
                <div>
                  <h3 className="font-bold text-lg leading-tight">{displayResult.message}</h3>
                  <p className="text-sm mt-2 opacity-80">
                    {displayResult.isWarning 
                      ? "Consider reviewing your non-essential spending." 
                      : "You are within your financial limits."}
                  </p>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
      
      <footer className="mt-8 text-center text-slate-400 text-sm">
        <p>© 2024 Budget Algorithm Tool • React Logic Port</p>
      </footer>
    </div>
  );
}