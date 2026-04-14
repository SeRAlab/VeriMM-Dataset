`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] pixel_in;
    reg valid;
    wire [15:0] encoded_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .pixel_in(pixel_in),
        .valid(valid),
        .encoded_out(encoded_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            rst = 1;
            pixel_in = 8'h0;
            @(posedge valid);
            @(posedge valid);
            #1 rst = 0;
            @(posedge valid);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic run of 3 pixels (0xAA)", test_num);
            reset_dut();

            pixel_in = 8'hAA;
            @(posedge valid);
            @(posedge valid);
            @(posedge valid);

            pixel_in = 8'hBB;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h03AA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single pixel run (0x11)", test_num);
            reset_dut();

            pixel_in = 8'h11;
            @(posedge valid);

            pixel_in = 8'h22;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h0111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Longer run of 10 pixels (0xFF)", test_num);
            reset_dut();

            pixel_in = 8'hFF;
            repeat(9) @(posedge valid);

            pixel_in = 8'h00;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h0AFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Run of zeros (0x00)", test_num);
            reset_dut();

            pixel_in = 8'h00;
            @(posedge valid);
            @(posedge valid);

            pixel_in = 8'h01;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h0200, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No output while run is active", test_num);
            reset_dut();

            pixel_in = 8'h55;
            @(posedge valid);
            pixel_in = 8'h55;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [15:0] expected_encoded_out;
        input expected_valid_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid_out=%b",
                         expected_encoded_out, expected_valid_out);
                $display("  Got:      encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
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
        $dumpvars(0,pixel_in, valid, encoded_out, valid_out);
    end

endmodule
