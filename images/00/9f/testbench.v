`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_read;
    wire [7:0] data_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .reset(reset),
        .start_read(start_read),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_read = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check...");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Byte Read Operation...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            #1;
            start_read = 1;
            @(posedge clk);
            #1;
            start_read = 0;


            fork : wait_for_done
                begin
                    wait(data_valid == 1'b1);
                    disable wait_for_done;
                end
                begin
                    repeat(100) @(posedge clk);
                    $display("  Error: data_valid timeout");
                    disable wait_for_done;
                end
            join



            #1;




            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Idle Stability...");
            test_num = test_num + 1;
            reset_dut();


            repeat(20) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Consecutive Reads...");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            start_read = 1;
            @(posedge clk);
            start_read = 0;
            wait(data_valid == 1'b1);
            @(posedge clk);


            start_read = 1;
            @(posedge clk);
            start_read = 0;
            wait(data_valid == 1'b1);

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset During Operation...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start_read = 1;
            @(posedge clk);
            start_read = 0;


            repeat(2) @(posedge clk);
            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_valid=%b",
                         data_out, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_valid=%b",
                         expected_data_out, expected_data_valid);
                $display("  Got:      data_out=%h, data_valid=%b",
                         data_out, data_valid);
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
        $dumpvars(0,clk, reset, start_read, data_out, data_valid);
    end

endmodule
