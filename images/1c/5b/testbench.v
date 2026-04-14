`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_input;
    reg reset;
    wire [2:0] current_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .clk(clk),
        .current_input(current_input),
        .reset(reset),
        .current_status(current_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_input = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset functionality", test_num);
            reset = 1;
            current_input = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Low Current Range (0 mA)", test_num);
            current_input = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Low Current Range (4 mA)", test_num);
            current_input = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Normal Current Range (5 mA)", test_num);
            current_input = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Normal Current Range (7 mA)", test_num);
            current_input = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Normal Current Range (9 mA)", test_num);
            current_input = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: High Current Range (10 mA)", test_num);
            current_input = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: High Current Range (15 mA)", test_num);
            current_input = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_current_status;
        begin
            if (expected_current_status === (expected_current_status ^ current_status ^ expected_current_status)) begin
                $display("PASS");
                $display("  Outputs: current_status=%h",
                         current_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_status=%h",
                         expected_current_status);
                $display("  Got:      current_status=%h",
                         current_status);
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
        $dumpvars(0,clk, current_input, reset, current_status);
    end

endmodule
