`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] alpha;
    reg clk;
    reg [31:0] grad;
    reg rst;
    reg [31:0] x;
    wire [31:0] new_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .clk(clk),
        .grad(grad),
        .rst(rst),
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
            alpha = 0;
            grad = 0;
            x = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x = 32'd100;
            alpha = 32'd2;
            grad = 32'd10;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Standard positive gradient", test_num);
            #1;

            check_outputs(32'd80);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x = 32'd50;
            alpha = 32'd5;
            grad = 32'd0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Zero gradient", test_num);
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x = 32'd10;
            alpha = 32'd2;
            grad = -32'd5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Negative gradient", test_num);
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x = 32'd1000;
            alpha = 32'd0;
            grad = 32'd50;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Zero learning rate", test_num);
            #1;

            check_outputs(32'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x = 32'd10;
            alpha = 32'd5;
            grad = 32'd10;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Update resulting in negative value", test_num);
            #1;

            check_outputs(-32'd40);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            x = 32'd10000;
            alpha = 32'd100;
            grad = 32'd50;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Larger integer values", test_num);
            #1;

            check_outputs(32'd5000);
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
        $dumpvars(0,alpha, clk, grad, rst, x, new_x);
    end

endmodule
