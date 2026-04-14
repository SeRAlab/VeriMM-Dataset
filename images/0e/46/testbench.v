`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] lr;
    reg rst;
    reg valid;
    reg [31:0] x;
    wire [31:0] new_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .lr(lr),
        .rst(rst),
        .valid(valid),
        .x(x),
        .new_x(new_x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            x = 0;
            lr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 32'd100;
            lr = 32'd10;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: x=100, lr=10 -> expected 90", test_num);
            #1;

            check_outputs(32'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 32'd50;
            lr = 32'd0;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: x=50, lr=0 -> expected 50", test_num);
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 32'd5;
            lr = 32'd15;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: x=5, lr=15 -> expected -10 (2's complement)", test_num);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            x = 32'd100;
            lr = 32'd10;
            valid = 1;
            @(posedge clk);
            #2;


            x = 32'd200;
            lr = 32'd50;
            valid = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Valid=0 -> expected output to remain 90", test_num);
            #1;

            check_outputs(32'd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 32'hFFFFFFFF;
            lr = 32'h00000001;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: x=Max, lr=1 -> expected Max-1", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [31:0] expected_new_x;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h",
                         new_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h",
                         expected_new_x);
                $display("  Got:      new_x=%h",
                         new_x);
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
        $dumpvars(0,clk, lr, rst, valid, x, new_x);
    end

endmodule
