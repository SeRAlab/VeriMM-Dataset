`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Run (4 identical bytes)", test_num);
            reset_dut();

            repeat(4) begin
                data_in = 8'hAA;
                valid_in = 1;
                @(posedge clk);
            end

            data_in = 8'h55;
            valid_in = 1;


            fork
                begin
                    wait(valid_out == 1);
                    #1;

                    check_outputs(16'hAA04, 1'b1);
                end
                begin
                    repeat(10) @(posedge clk);
                end
            join_any
            valid_in = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte Run", test_num);
            reset_dut();

            data_in = 8'h12;
            valid_in = 1;
            @(posedge clk);

            data_in = 8'h34;
            valid_in = 1;

            wait(valid_out == 1);
            #1;

            check_outputs(16'h1201, 1'b1);

            valid_in = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Run Length (255 bytes)", test_num);
            reset_dut();

            for (i = 0; i < 255; i = i + 1) begin
                data_in = 8'hFF;
                valid_in = 1;
                @(posedge clk);
            end

            data_in = 8'h00;
            valid_in = 1;

            wait(valid_out == 1);
            #1;

            check_outputs(16'hFFFF, 1'b1);

            valid_in = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during run", test_num);
            reset_dut();

            repeat(2) begin
                data_in = 8'hEE;
                valid_in = 1;
                @(posedge clk);
            end

            reset = 1; @(posedge clk); reset = 0;

            repeat(2) begin
                data_in = 8'h99;
                valid_in = 1;
                @(posedge clk);
            end

            data_in = 8'h00;
            valid_in = 1;

            wait(valid_out == 1);
            #1;

            check_outputs(16'h9902, 1'b1);

            valid_in = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple consecutive runs", test_num);
            reset_dut();


            repeat(2) begin
                data_in = 8'h11; valid_in = 1; @(posedge clk);
            end

            repeat(3) begin
                data_in = 8'h22; valid_in = 1;
                if (valid_out) #1;
 check_outputs(16'h1102, 1'b1);
                @(posedge clk);
            end

            data_in = 8'h33; valid_in = 1;
            wait(valid_out == 1);
            #1;

            check_outputs(16'h2203, 1'b1);

            valid_in = 0;
            repeat(2) @(posedge clk);
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
        input [15:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, valid_out);
    end

endmodule
