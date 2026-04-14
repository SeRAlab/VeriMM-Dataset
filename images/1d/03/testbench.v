`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received_bits;
    reg reset;
    wire [3:0] decoded_output;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bits(received_bits),
        .reset(reset),
        .decoded_output(decoded_output),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            received_bits = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Clean Channel)", test_num);
            reset_dut();


            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b00;


            wait(valid_output === 1);
            @(posedge clk);

            #1;


            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1011 (Clean Channel)", test_num);
            reset_dut();


            @(posedge clk) received_bits = 2'b11;
            @(posedge clk) received_bits = 2'b10;
            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b10;

            wait(valid_output === 1);
            @(posedge clk);

            #1;


            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros with Single Bit Error", test_num);
            reset_dut();

            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b01;
            @(posedge clk) received_bits = 2'b00;
            @(posedge clk) received_bits = 2'b00;

            wait(valid_output === 1);
            @(posedge clk);


            #1;



            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (Clean Channel)", test_num);
            reset_dut();


            @(posedge clk) received_bits = 2'b11;
            @(posedge clk) received_bits = 2'b01;
            @(posedge clk) received_bits = 2'b10;
            @(posedge clk) received_bits = 2'b10;

            wait(valid_output === 1);
            @(posedge clk);

            #1;


            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1100 with Dual Bit Errors", test_num);
            reset_dut();

            @(posedge clk) received_bits = 2'b10;
            @(posedge clk) received_bits = 2'b01;
            @(posedge clk) received_bits = 2'b01;
            @(posedge clk) received_bits = 2'b11;

            wait(valid_output === 1);
            @(posedge clk);


            #1;



            check_outputs(4'b1100, 1'b1);
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
        input [3:0] expected_decoded_output;
        input expected_valid_output;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, valid_output=%b",
                         decoded_output, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, valid_output=%b",
                         expected_decoded_output, expected_valid_output);
                $display("  Got:      decoded_output=%h, valid_output=%b",
                         decoded_output, valid_output);
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
        $dumpvars(0,clk, received_bits, reset, decoded_output, valid_output);
    end

endmodule
