`timescale 1ns/1ps

module mPshBtnDbnce_tb;

    // Testbench signals (sequential circuit)
    reg i_Clk;
    reg i_PshBtn;
    wire o_Dbnced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mPshBtnDbnce dut (
        .i_Clk(i_Clk),
        .i_PshBtn(i_PshBtn),
        .o_Dbnced(o_Dbnced)
    );

    // Clock generation (10ns period)
    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mPshBtnDbnce Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_o_Dbnced;
        begin
            if (expected_o_Dbnced === (expected_o_Dbnced ^ o_Dbnced ^ expected_o_Dbnced)) begin
                $display("PASS");
                $display("  Outputs: o_Dbnced=%b",
                         o_Dbnced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Dbnced=%b",
                         expected_o_Dbnced);
                $display("  Got:      o_Dbnced=%b",
                         o_Dbnced);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_Clk, i_PshBtn, o_Dbnced);
    end

endmodule
