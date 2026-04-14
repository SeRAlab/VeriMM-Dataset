`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg operation;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .operation(operation),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_a = 0;
            data_b = 0;
            operation = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'h0A;
            data_b = 8'h14;
            operation = 0;
            @(posedge clk);

            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h1E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'h32;
            data_b = 8'h14;
            operation = 1;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h1E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'hC8;
            data_b = 8'h64;
            operation = 0;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h2C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'h0A;
            data_b = 8'h14;
            operation = 1;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'h80;
            data_b = 8'h80;
            operation = 1;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'hFF;
            data_b = 8'hFF;
            operation = 0;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_a = 8'hFF;
            data_b = 8'h00;
            operation = 1;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_a, data_b, operation, reset, result);
    end

endmodule
