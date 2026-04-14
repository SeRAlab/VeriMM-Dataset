`timescale 1ns/1ps

module deserializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 8'h0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Loading 0x12 then 0x34", test_num);
            reset_dut();


            data_in = 8'h12;
            valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h34;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Loading 0x00 then 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'h00;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Loading 0xFF then 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'hFF;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Loading 0xAA then 0x55", test_num);
            reset_dut();

            data_in = 8'hAA;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'h55;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(16'hAA55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Loading 0xDE then 0xAD", test_num);
            reset_dut();

            data_in = 8'hDE;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'hAD;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, valid, data_out);
    end

endmodule
