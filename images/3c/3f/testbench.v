`timescale 1ns/1ps

module slam_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] x_disp;
    reg [7:0] y_disp;
    wire [15:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam dut (
        .clk(clk),
        .rst(rst),
        .x_disp(x_disp),
        .y_disp(y_disp),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_disp = 0;
            y_disp = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Positive displacement", test_num);
            reset_dut();
            x_disp = 8'd10;
            y_disp = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0A14);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Move and return to origin", test_num);
            reset_dut();

            x_disp = 8'd50;
            y_disp = 8'd50;
            @(posedge clk);
            #1;

            x_disp = -8'd50;
            y_disp = -8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative displacement", test_num);
            reset_dut();
            x_disp = -8'd10;
            y_disp = -8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF6F1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multi-step accumulation", test_num);
            reset_dut();

            x_disp = 8'd10; y_disp = 8'd10;
            @(posedge clk);
            #1;

            x_disp = 8'd20; y_disp = -8'd5;
            @(posedge clk);
            #1;

            x_disp = -8'd5; y_disp = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1914);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum 8-bit signed range", test_num);
            reset_dut();
            x_disp = 8'd127;
            y_disp = 8'd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7F7F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Minimum 8-bit signed range", test_num);
            reset_dut();
            x_disp = -8'd128;
            y_disp = -8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8080);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Signed wrap-around check", test_num);
            reset_dut();
            x_disp = 8'd120;
            y_disp = 8'd120;
            @(posedge clk);
            #1;
            x_disp = 8'd10;
            y_disp = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8282);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam Testbench");
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
        input [15:0] expected_position;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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
        $dumpvars(0,clk, rst, x_disp, y_disp, position);
    end

endmodule
