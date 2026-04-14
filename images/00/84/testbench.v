`timescale 1ns/1ps

module turbo_encoder_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire decoded_out;
    wire [1:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder_decoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .decoded_out(decoded_out),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Single bit 0", test_num);
            reset_dut();
            data_in = 0;
            @(posedge clk);
            data_in = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Single bit 1", test_num);
            reset_dut();
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Sequence 1-0", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Alternating sequence 1-0-1", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Consecutive 1-1-1", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder_decoder Testbench");
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
        input expected_decoded_out;
        input [1:0] expected_encoded_out;
        begin
            if (expected_decoded_out === (expected_decoded_out ^ decoded_out ^ expected_decoded_out) &&
                expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: decoded_out=%b, encoded_out=%h",
                         decoded_out, encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_out=%b, encoded_out=%h",
                         expected_decoded_out, expected_encoded_out);
                $display("  Got:      decoded_out=%b, encoded_out=%h",
                         decoded_out, encoded_out);
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
        $dumpvars(0,clk, data_in, rst, decoded_out, encoded_out);
    end

endmodule
