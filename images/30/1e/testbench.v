`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] pixel_in;
    reg pixel_valid;
    wire [7:0] count_out;
    wire output_valid;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .count_out(count_out),
        .output_valid(output_valid),
        .pixel_out(pixel_out)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_valid = 0;
        forever #5 pixel_valid = ~pixel_valid;
    end

        task reset_dut;

        begin
            pixel_in = 8'h00;
            repeat(2) @(negedge pixel_valid);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Run of 3 identical pixels", test_num);
            reset_dut();


            @(negedge pixel_valid) pixel_in = 8'hAA;
            repeat(3) @(negedge pixel_valid);


            pixel_in = 8'hBB;
            @(posedge pixel_valid);


            #1 #1;
 check_outputs(8'd3, 1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single pixel run", test_num);
            reset_dut();


            @(negedge pixel_valid) pixel_in = 8'h12;
            @(negedge pixel_valid);


            pixel_in = 8'h34;
            @(posedge pixel_valid);


            #1 #1;
 check_outputs(8'd1, 1'b1, 8'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Run of 10 pixels", test_num);
            reset_dut();


            @(negedge pixel_valid) pixel_in = 8'hFF;
            repeat(10) @(negedge pixel_valid);


            pixel_in = 8'h00;
            @(posedge pixel_valid);


            #1 #1;
 check_outputs(8'd10, 1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Maximum 8-bit count (255)", test_num);
            reset_dut();


            @(negedge pixel_valid) pixel_in = 8'hCC;
            for (i = 0; i < 255; i = i + 1) begin
                @(negedge pixel_valid);
            end


            pixel_in = 8'hDD;
            @(posedge pixel_valid);


            #1 #1;
 check_outputs(8'd255, 1'b1, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Consecutive runs (Checking the second run)", test_num);
            reset_dut();


            @(negedge pixel_valid) pixel_in = 8'h11;
            repeat(2) @(negedge pixel_valid);


            pixel_in = 8'h22;
            repeat(4) @(negedge pixel_valid);


            pixel_in = 8'h33;
            @(posedge pixel_valid);


            #1 #1;
 check_outputs(8'd4, 1'b1, 8'h22);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE Testbench");
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
        input [7:0] expected_count_out;
        input expected_output_valid;
        input [7:0] expected_pixel_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, output_valid=%b, pixel_out=%h",
                         count_out, output_valid, pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, output_valid=%b, pixel_out=%h",
                         expected_count_out, expected_output_valid, expected_pixel_out);
                $display("  Got:      count_out=%h, output_valid=%b, pixel_out=%h",
                         count_out, output_valid, pixel_out);
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
        $dumpvars(0,pixel_in, pixel_valid, count_out, output_valid, pixel_out);
    end

endmodule
