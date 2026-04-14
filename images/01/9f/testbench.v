`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid;
    wire [15:0] data_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
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
            rst = 1;
            valid = 0;
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic 2-cycle conversion (0x12, 0x34)", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h12; valid = 1;
            @(posedge clk);
            data_in = 8'h34; valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input valid gating", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hAA; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 8'hFF;
            @(posedge clk);
            valid = 0; data_in = 8'h00;
            @(posedge clk);
            data_in = 8'hBB; valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'hAABB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Back-to-back transactions", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h11; valid = 1;
            @(posedge clk);
            data_in = 8'h22; valid = 1;


            @(posedge clk);
            data_in = 8'h33; valid = 1;
            @(posedge clk);
            data_in = 8'h44; valid = 1;

            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h3344, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during transaction", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h55; valid = 1;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            data_in = 8'hAA; valid = 1;
            @(posedge clk);
            data_in = 8'hBB; valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'hAABB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output hold when valid is low", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hDE; valid = 1;
            @(posedge clk);
            data_in = 8'hAD; valid = 1;
            @(posedge clk);

            valid = 0;
            data_in = 8'hFF;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'hDEAD, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        $dumpvars(0,clk, data_in, rst, valid, data_out, data_valid);
    end

endmodule
