`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data1;
    reg [7:0] data2;
    reg reset;
    reg start;
    wire done;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .reset(reset),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            start = 0;
            data1 = 8'h0;
            data2 = 8'h0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hAA AND 8'h55", test_num);
            reset_dut();
            data1 = 8'hAA;
            data2 = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hFF AND 8'hFF", test_num);
            reset_dut();
            data1 = 8'hFF;
            data2 = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'h00 AND 8'h00", test_num);
            reset_dut();
            data1 = 8'h00;
            data2 = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hF0 AND 8'h0F", test_num);
            reset_dut();
            data1 = 8'hF0;
            data2 = 8'h0F;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hC3 AND 8'h3C", test_num);
            reset_dut();
            data1 = 8'hC3;
            data2 = 8'h3C;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hA5 AND 8'hA5", test_num);
            reset_dut();
            data1 = 8'hA5;
            data2 = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'h01 AND 8'h81", test_num);
            reset_dut();
            data1 = 8'h01;
            data2 = 8'h81;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'h12 AND 8'h34", test_num);
            reset_dut();
            data1 = 8'h12;
            data2 = 8'h34;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'hFF AND 8'h00", test_num);
            reset_dut();
            data1 = 8'hFF;
            data2 = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8'h80 AND 8'h01", test_num);
            reset_dut();
            data1 = 8'h80;
            data2 = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,clk, data1, data2, reset, start, done, result);
    end

endmodule
