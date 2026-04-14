`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] alpha;
    reg clk;
    reg [15:0] g;
    reg rst;
    reg [15:0] x;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .clk(clk),
        .g(g),
        .rst(rst),
        .x(x),
        .x_new(x_new)
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
            g = 0;
            x = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Basic operation (500 - 2*50)", test_num);
            x = 16'd500;
            alpha = 16'd2;
            g = 16'd50;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd400);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Zero learning rate (1000 - 0*100)", test_num);
            x = 16'd1000;
            alpha = 16'd0;
            g = 16'd100;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Zero gradient (750 - 5*0)", test_num);
            x = 16'd750;
            alpha = 16'd5;
            g = 16'd0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd750);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Underflow result (10 - 2*10)", test_num);
            x = 16'd10;
            alpha = 16'd2;
            g = 16'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Large value arithmetic (30000 - 10*1000)", test_num);
            x = 16'd30000;
            alpha = 16'd10;
            g = 16'd1000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd20000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: High product causing significant wrap (100 - 255*255)", test_num);
            x = 16'd100;
            alpha = 16'd255;
            g = 16'd255;


            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd611);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Operation after second reset", test_num);
            x = 16'hAAAA;
            alpha = 16'h0001;
            g = 16'h0001;

            @(posedge clk);
            #2;

            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            x = 16'h5555;
            alpha = 16'h0002;
            g = 16'h0003;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h554F);
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
        input [15:0] expected_x_new;
        begin
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h",
                         x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h",
                         expected_x_new);
                $display("  Got:      x_new=%h",
                         x_new);
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
        $dumpvars(0,alpha, clk, g, rst, x, x_new);
    end

endmodule
