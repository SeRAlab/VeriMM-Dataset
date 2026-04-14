`timescale 1ns/1ps

module PC_tb;

    // Testbench signals (sequential circuit)
    reg CP;
    reg EP;
    reg clk;
    reg rst;
    wire [3:0] PC_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PC dut (
        .CP(CP),
        .EP(EP),
        .clk(clk),
        .rst(rst),
        .PC_OUT(PC_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            CP = 0;
            EP = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset and Output Enable", test_num);
            reset_dut();
            EP = 1;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Incrementing (3 steps)", test_num);
            reset_dut();
            EP = 1;
            CP = 1;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EP Control (Output Masking)", test_num);
            reset_dut();
            CP = 1;
            EP = 1;
            repeat(5) @(posedge clk);
            EP = 0;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CP Control (Hold value)", test_num);
            reset_dut();
            EP = 1;
            CP = 1;
            repeat(4) @(posedge clk);
            CP = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Wrapping (15 to 0)", test_num);
            reset_dut();
            EP = 1;
            CP = 1;
            repeat(16) @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Priority", test_num);
            reset_dut();
            EP = 1;
            CP = 1;
            repeat(7) @(posedge clk);
            #2;
            rst = 1;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CP and EP Low", test_num);
            reset_dut();
            CP = 0;
            EP = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PC Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_PC_OUT;
        begin
            if (expected_PC_OUT === (expected_PC_OUT ^ PC_OUT ^ expected_PC_OUT)) begin
                $display("PASS");
                $display("  Outputs: PC_OUT=%h",
                         PC_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_OUT=%h",
                         expected_PC_OUT);
                $display("  Got:      PC_OUT=%h",
                         PC_OUT);
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
        $dumpvars(0,CP, EP, clk, rst, PC_OUT);
    end

endmodule
