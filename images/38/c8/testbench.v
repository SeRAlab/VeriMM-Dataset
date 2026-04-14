`timescale 1ns/1ps

module TempSensorController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] new_temp;
    reg new_temp_valid;
    reg read_max;
    reg rst;
    wire [7:0] max_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TempSensorController dut (
        .clk(clk),
        .new_temp(new_temp),
        .new_temp_valid(new_temp_valid),
        .read_max(read_max),
        .rst(rst),
        .max_temp(max_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            new_temp = 0;
            new_temp_valid = 0;
            read_max = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();
            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single temperature update", test_num);
            reset_dut();

            new_temp = 8'd75;
            new_temp_valid = 1;
            @(posedge clk);
            #1 new_temp_valid = 0;

            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd75);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple increasing temperatures", test_num);
            reset_dut();


            new_temp_valid = 1;
            new_temp = 8'd10; @(posedge clk);
            new_temp = 8'd45; @(posedge clk);
            new_temp = 8'd120; @(posedge clk);
            #1 new_temp_valid = 0;

            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Lower values should not update max", test_num);
            reset_dut();

            new_temp_valid = 1;
            new_temp = 8'd100; @(posedge clk);
            new_temp = 8'd50;  @(posedge clk);
            new_temp = 8'd99;  @(posedge clk);
            #1 new_temp_valid = 0;

            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verification of valid bit gating", test_num);
            reset_dut();


            new_temp = 8'd200;
            new_temp_valid = 0;
            @(posedge clk);


            new_temp = 8'd40;
            new_temp_valid = 1;
            @(posedge clk);
            #1 new_temp_valid = 0;

            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary value (255)", test_num);
            reset_dut();

            new_temp_valid = 1;
            new_temp = 8'd255;
            @(posedge clk);
            #1 new_temp_valid = 0;

            read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: read_max signal behavior", test_num);
            reset_dut();

            new_temp_valid = 1;
            new_temp = 8'd150;
            @(posedge clk);
            #1 new_temp_valid = 0;


            read_max = 0;
            @(posedge clk);

            #1 read_max = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd150);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TempSensorController Testbench");
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
        input [7:0] expected_max_temp;
        begin
            if (expected_max_temp === (expected_max_temp ^ max_temp ^ expected_max_temp)) begin
                $display("PASS");
                $display("  Outputs: max_temp=%h",
                         max_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_temp=%h",
                         expected_max_temp);
                $display("  Got:      max_temp=%h",
                         max_temp);
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
        $dumpvars(0,clk, new_temp, new_temp_valid, read_max, rst, max_temp);
    end

endmodule
