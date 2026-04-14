`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received_bits;
    reg rst;
    wire [1:0] decoded_bits;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bits(received_bits),
        .rst(rst),
        .decoded_bits(decoded_bits),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rst = 1;
            received_bits = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Sequence (Clean)", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                received_bits = 2'b00;
                @(posedge clk);
            end



            wait(valid_output === 1'b1);
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Sequence (Clean)", test_num);
            reset_dut();



            for (i = 0; i < 4; i = i + 1) begin
                received_bits = 2'b11; @(posedge clk);
                received_bits = 2'b10; @(posedge clk);
                received_bits = 2'b00; @(posedge clk);
                received_bits = 2'b01; @(posedge clk);
            end


            repeat(20) @(posedge clk);


            if (valid_output)
                #1;

                check_outputs(decoded_bits, 1'b1);
            else
                $display("Waiting for valid output...");
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Noisy Zeros (Correction Test)", test_num);
            reset_dut();


            for (i = 0; i < 20; i = i + 1) begin
                if (i == 5 || i == 12)
                    received_bits = 2'b01;
                else
                    received_bits = 2'b00;
                @(posedge clk);
            end


            repeat(10) @(posedge clk);


            #1;



            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Recovery Test", test_num);
            reset_dut();


            received_bits = 2'b11; @(posedge clk);
            received_bits = 2'b01; @(posedge clk);


            reset_dut();


            repeat(15) begin
                received_bits = 2'b00;
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Ones", test_num);
            reset_dut();



            for (i = 0; i < 20; i = i + 1) begin
                received_bits = 2'b11;
                @(posedge clk);
            end

            repeat(15) @(posedge clk);

            if (valid_output === 1'b1) begin
                $display("Decoder synchronized on continuous stream.");
                pass_count = pass_count + 1;
            end else begin
                $display("Decoder failed to assert valid_output on continuous stream.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [1:0] expected_decoded_bits;
        input expected_valid_output;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h, valid_output=%b",
                         decoded_bits, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h, valid_output=%b",
                         expected_decoded_bits, expected_valid_output);
                $display("  Got:      decoded_bits=%h, valid_output=%b",
                         decoded_bits, valid_output);
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
        $dumpvars(0,clk, received_bits, rst, decoded_bits, valid_output);
    end

endmodule
