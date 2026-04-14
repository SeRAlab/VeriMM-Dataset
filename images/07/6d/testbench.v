`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] add_out;
    wire [7:0] mul_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .add_out(add_out),
        .mul_out(mul_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'b0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 5", test_num);
            data_in = 8'd5;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10, 8'd20);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 20", test_num);
            data_in = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40, 8'd80);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (Input = 80)", test_num);
            data_in = 8'd80;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd160, 8'd64);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (Input = 130)", test_num);
            data_in = 8'd130;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4, 8'd8);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Input (255)", test_num);
            data_in = 8'd255;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd254, 8'd252);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input", test_num);
            data_in = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Pipelined Flow (Continuity Test)", test_num);

            data_in = 8'd10;
            @(posedge clk);

            data_in = 8'd30;
            @(posedge clk);



            #1 #1;
 check_outputs(8'd60, 8'd40);
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
        input [7:0] expected_add_out;
        input [7:0] expected_mul_out;
        begin
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_mul_out === (expected_mul_out ^ mul_out ^ expected_mul_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, mul_out=%h",
                         add_out, mul_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, mul_out=%h",
                         expected_add_out, expected_mul_out);
                $display("  Got:      add_out=%h, mul_out=%h",
                         add_out, mul_out);
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
        $dumpvars(0,clk, data_in, reset, add_out, mul_out);
    end

endmodule
