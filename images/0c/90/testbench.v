`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    wire [7:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .in_data(in_data),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_data = 8'd0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic functional test (Input: 5)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd5;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing with Zero (Input: 0)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing mid-range value (Input: 20)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd20;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing 8-bit overflow (Input: 127)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd127;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing near overflow (Input: 126)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd126;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd254);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing wrap-around on increment (Input: 255)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd255;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing value 100 (Input: 100)", test_num);
            reset_dut();
            @(negedge clk);
            in_data = 8'd100;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd202);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [7:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, out_data);
    end

endmodule
