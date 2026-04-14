`timescale 1ns/1ps

module temp_shutdown_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_shutdown_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 8'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Below threshold (Normal Operation)", test_num);
            reset_dut();
            temperature = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Temperature exactly at threshold (100)", test_num);
            reset_dut();
            temperature = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Temperature just above threshold (101)", test_num);
            reset_dut();
            temperature = 8'd101;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maximum temperature (255)", test_num);
            reset_dut();
            temperature = 8'd255;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reset clearing active shutdown", test_num);
            reset_dut();

            temperature = 8'd120;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Fluctuating temperature below threshold", test_num);
            reset_dut();
            temperature = 8'd10;
            @(posedge clk);
            temperature = 8'd99;
            @(posedge clk);
            temperature = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_shutdown_controller Testbench");
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
        input expected_shutdown;
        begin
            if (expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown)) begin
                $display("PASS");
                $display("  Outputs: shutdown=%b",
                         shutdown);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown=%b",
                         expected_shutdown);
                $display("  Got:      shutdown=%b",
                         shutdown);
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
        $dumpvars(0,clk, reset, temperature, shutdown);
    end

endmodule
