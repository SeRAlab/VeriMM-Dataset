`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] workload;
    wire [7:0] Fout;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .workload(workload),
        .Fout(Fout),
        .Vout(Vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            workload = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Reset state (Lowest values)", test_num);
            reset_dut();

            #1 #1;
 check_outputs(8'd10, 8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Workload 0", test_num);
            reset_dut();
            workload = 2'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10, 8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Workload 1", test_num);
            reset_dut();
            workload = 2'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd12, 8'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Workload 2", test_num);
            reset_dut();
            workload = 2'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd15, 8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Workload 3", test_num);
            reset_dut();
            workload = 2'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd18, 8'd18);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Transition Workload 3 to 0", test_num);
            reset_dut();
            workload = 2'd3;
            @(posedge clk);
            workload = 2'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10, 8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential stepping (0->1->2)", test_num);
            reset_dut();
            workload = 2'd0;
            @(posedge clk);
            workload = 2'd1;
            @(posedge clk);
            workload = 2'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd15, 8'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [7:0] expected_Fout;
        input [7:0] expected_Vout;
        begin
            if (expected_Fout === (expected_Fout ^ Fout ^ expected_Fout) &&
                expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Fout=%h, Vout=%h",
                         Fout, Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Fout=%h, Vout=%h",
                         expected_Fout, expected_Vout);
                $display("  Got:      Fout=%h, Vout=%h",
                         Fout, Vout);
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
        $dumpvars(0,clk, reset, workload, Fout, Vout);
    end

endmodule
