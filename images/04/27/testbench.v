`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [11:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task drive_input;

        input [7:0] val;
        begin
            @(posedge clk);
            #1;
            data_in = val;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            data_in = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            drive_input(8'h00);


            repeat(4) @(posedge clk);

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single bit high (8'h01)", test_num);
            reset_dut();
            drive_input(8'h01);

            repeat(4) @(posedge clk);



            #1;




            check_outputs(12'h011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones (8'hFF)", test_num);
            reset_dut();
            drive_input(8'hFF);

            repeat(4) @(posedge clk);

            #1;


            check_outputs(12'hFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (8'hAA)", test_num);
            reset_dut();
            drive_input(8'hAA);

            repeat(4) @(posedge clk);

            #1;


            check_outputs(12'hAA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern 8'h55", test_num);
            reset_dut();
            drive_input(8'h55);

            repeat(4) @(posedge clk);

            #1;


            check_outputs(12'h55A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Specific Data 8'hC3", test_num);
            reset_dut();
            drive_input(8'hC3);

            repeat(4) @(posedge clk);

            #1;


            check_outputs(12'hC3F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ReedSolomonEncoder Testbench");
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
        input [11:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, data_in, enable, reset, encoded_out);
    end

endmodule
