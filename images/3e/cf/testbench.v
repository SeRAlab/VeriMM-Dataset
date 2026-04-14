`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [9:0] temp_input;
    wire [3:0] temp_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .clk(clk),
        .rst(rst),
        .temp_input(temp_input),
        .temp_output(temp_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temp_input = 10'd0;
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
            $display("Test Case %0d: Input 0", test_num);
            temp_input = 10'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Input 100", test_num);
            temp_input = 10'd100;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Input 101", test_num);
            temp_input = 10'd101;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Input 300", test_num);
            temp_input = 10'd300;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Input 450", test_num);
            temp_input = 10'd450;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Input 601", test_num);
            temp_input = 10'd601;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd6);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Input 800", test_num);
            temp_input = 10'd800;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Input 801", test_num);
            temp_input = 10'd801;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test Case %0d: Input 901", test_num);
            temp_input = 10'd901;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd9);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Test Case %0d: Input 1023", test_num);
            temp_input = 10'd1023;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd9);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
            testcase004();
            testcase005();
        end
        endtask

    task testcases2;

        begin
            testcase006();
            testcase007();
            testcase008();
            testcase009();
            testcase010();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
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
        testcases1();
        testcases2();
        
        
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
        input [3:0] expected_temp_output;
        begin
            if (expected_temp_output === (expected_temp_output ^ temp_output ^ expected_temp_output)) begin
                $display("PASS");
                $display("  Outputs: temp_output=%h",
                         temp_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_output=%h",
                         expected_temp_output);
                $display("  Got:      temp_output=%h",
                         temp_output);
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
        $dumpvars(0,clk, rst, temp_input, temp_output);
    end

endmodule
