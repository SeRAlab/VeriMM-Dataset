`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg SI;
    wire [4:0] SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .CLK(CLK),
        .RST(RST),
        .SI(SI),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            SI = 0;
            @(posedge CLK);
            #1 RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            @(posedge CLK);
            #1 #1;
 check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift All Ones", test_num);
            reset_dut();
            repeat(5) begin
                SI = 1;
                @(posedge CLK);
            end
            #1 #1;
 check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Pattern 10101", test_num);
            reset_dut();






            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            #1 #1;
 check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Shift (8 bits)", test_num);
            reset_dut();


            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            #1 #1;
 check_outputs(5'b11010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset after partial shift", test_num);
            reset_dut();
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            reset_dut();
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            #1 #1;
 check_outputs(5'b10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SISO_Shift_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%h",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%h",
                         expected_SO);
                $display("  Got:      SO=%h",
                         SO);
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
        $dumpvars(0,CLK, RST, SI, SO);
    end

endmodule
