`timescale 1ns/1ps

module run_length_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg rst;
    wire [7:0] length;
    wire valid;
    wire value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    run_length_encoder dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .length(length),
        .valid(valid),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of four 0s", test_num);
            reset_dut();


            repeat(4) begin
                data = 0;
                @(posedge clk);
            end


            data = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd4, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of five 1s", test_num);
            reset_dut();



            repeat(5) begin
                data = 1;
                @(posedge clk);
            end


            data = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum run (length 1)", test_num);
            reset_dut();

            data = 0;
            @(posedge clk);


            data = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify alternating trigger", test_num);
            reset_dut();


            data = 1; @(posedge clk);
            data = 1; @(posedge clk);


            data = 0; @(posedge clk);
            #1;


            data = 0; @(posedge clk);
            data = 1; @(posedge clk);
            #1;


            #1;



            check_outputs(8'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of ten 0s", test_num);
            reset_dut();

            repeat(10) begin
                data = 0;
                @(posedge clk);
            end

            data = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd10, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("run_length_encoder Testbench");
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
        input [7:0] expected_length;
        input expected_valid;
        input expected_value;
        begin
            if (expected_length === (expected_length ^ length ^ expected_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: length=%h, valid=%b, value=%b",
                         length, valid, value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: length=%h, valid=%b, value=%b",
                         expected_length, expected_valid, expected_value);
                $display("  Got:      length=%h, valid=%b, value=%b",
                         length, valid, value);
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
        $dumpvars(0,clk, data, rst, length, valid, value);
    end

endmodule
