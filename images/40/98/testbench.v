`timescale 1ns/1ps

module temperature_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [3:0] temp_in;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_shutdown dut (
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp_in),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            temp_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature = 5 (Below Threshold)", test_num);
            reset_dut();
            temp_in = 4'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature = 11 (Just below Threshold)", test_num);
            reset_dut();
            temp_in = 4'd11;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature = 12 (At Threshold)", test_num);
            reset_dut();
            temp_in = 4'd12;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature = 15 (Above Threshold)", test_num);
            reset_dut();
            temp_in = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 14 -> 10 (Recovery)", test_num);
            reset_dut();

            temp_in = 4'd14;
            @(posedge clk);

            temp_in = 4'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature = 0 (Minimum)", test_num);
            reset_dut();
            temp_in = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained High Temperature", test_num);
            reset_dut();
            temp_in = 4'd13;
            @(posedge clk);
            @(posedge clk);
            temp_in = 4'd14;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_shutdown Testbench");
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
        $dumpvars(0,clk, rst_n, temp_in, shutdown);
    end

endmodule
