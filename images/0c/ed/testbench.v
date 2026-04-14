`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] target;
    reg [1:0] x;
    wire done;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .rst(rst),
        .target(target),
        .x(x),
        .done(done),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            target = 2'b00;
            x = 2'b00;
            #20;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Learning Target 01 with Inputs 11", test_num);
            reset_dut();

            x = 2'b11;
            target = 2'b01;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Learning Target 10 with Inputs 01", test_num);
            reset_dut();

            x = 2'b01;
            target = 2'b10;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Learning Target 11 with Inputs 10", test_num);
            reset_dut();

            x = 2'b10;
            target = 2'b11;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Learning Target 00 with Inputs 11", test_num);
            reset_dut();

            x = 2'b11;
            target = 2'b00;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Inputs Test (Target 11, Inputs 00)", test_num);
            reset_dut();

            x = 2'b00;
            target = 2'b11;

            wait(done);
            @(posedge clk);



            #1;




            check_outputs(1'b1, y);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input expected_done;
        input [1:0] expected_y;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: done=%b, y=%h",
                         done, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, y=%h",
                         expected_done, expected_y);
                $display("  Got:      done=%b, y=%h",
                         done, y);
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
        $dumpvars(0,clk, rst, target, x, done, y);
    end

endmodule
