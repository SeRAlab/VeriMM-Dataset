`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] encoded_bits;
    reg reset;
    wire [3:0] decoded_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .encoded_bits(encoded_bits),
        .reset(reset),
        .decoded_bits(decoded_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        encoded_bits = 2'b00;
        repeat (2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        reset_dut();


        repeat(4) begin
            encoded_bits = 2'b00;
            @(posedge clk);
        end


        repeat(5) @(posedge clk);

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Data Sequence 1011", test_num);
        reset_dut();

        encoded_bits = 2'b11; @(posedge clk);
        encoded_bits = 2'b11; @(posedge clk);
        encoded_bits = 2'b00; @(posedge clk);
        encoded_bits = 2'b10; @(posedge clk);


        repeat(5) @(posedge clk);

        #1;


        check_outputs(4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Error Correction (1-bit flip)", test_num);
        reset_dut();

        encoded_bits = 2'b01;
        @(posedge clk);
        encoded_bits = 2'b11; @(posedge clk);
        encoded_bits = 2'b01; @(posedge clk);
        encoded_bits = 2'b11; @(posedge clk);


        repeat(5) @(posedge clk);

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: All Ones", test_num);
        reset_dut();

        encoded_bits = 2'b11; @(posedge clk);
        encoded_bits = 2'b00; @(posedge clk);
        encoded_bits = 2'b10; @(posedge clk);
        encoded_bits = 2'b01; @(posedge clk);


        repeat(5) @(posedge clk);

        #1;


        check_outputs(4'b1111);
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
        input [3:0] expected_decoded_bits;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h",
                         decoded_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h",
                         expected_decoded_bits);
                $display("  Got:      decoded_bits=%h",
                         decoded_bits);
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
        $dumpvars(0,clk, encoded_bits, reset, decoded_bits);
    end

endmodule
