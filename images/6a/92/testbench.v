`timescale 1ns/1ps

module BiDirShiftReg_4_tb;

    // Testbench signals (sequential circuit)
    reg SI_L;
    reg SI_R;
    reg clk;
    reg dir;
    reg rst;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BiDirShiftReg_4 dut (
        .SI_L(SI_L),
        .SI_R(SI_R),
        .clk(clk),
        .dir(dir),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            SI_L = 0;
            SI_R = 0;
            dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Synchronous Reset", test_num);
            reset_dut();
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Left Shift - Fill with 1s", test_num);
            reset_dut();
            dir = 1; SI_L = 1;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Right Shift - Fill with 1s", test_num);
            reset_dut();
            dir = 0; SI_R = 1;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Left Shift Pattern 1010", test_num);
            reset_dut();
            dir = 1;
            @(posedge clk) SI_L = 1;
            @(posedge clk) SI_L = 0;
            @(posedge clk) SI_L = 1;
            @(posedge clk) SI_L = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Right Shift Pattern 0101", test_num);
            reset_dut();
            dir = 0;





            @(posedge clk) SI_R = 1;
            @(posedge clk) SI_R = 0;
            @(posedge clk) SI_R = 1;
            @(posedge clk) SI_R = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Bidirectional Mixed", test_num);
            reset_dut();

            dir = 1; SI_L = 1;
            repeat(4) @(posedge clk);

            dir = 0; SI_R = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BiDirShiftReg_4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,SI_L, SI_R, clk, dir, rst, Q);
    end

endmodule
