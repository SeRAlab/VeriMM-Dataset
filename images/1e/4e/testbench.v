`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg in_en;
    reg rst;
    wire data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .in_en(in_en),
        .rst(rst),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_serializer_test;

        input [15:0] value;
        integer i;
        begin

            data_in = value;
            in_en = 1;


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);

                #1;


                check_outputs(value[i], 1'b1);
            end


            in_en = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All Zeros (16'h0000)", test_num);
            reset_dut();
            run_serializer_test(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All Ones (16'hFFFF)", test_num);
            reset_dut();
            run_serializer_test(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Alternating 1010 (16'hAAAA)", test_num);
            reset_dut();
            run_serializer_test(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Alternating 0101 (16'h5555)", test_num);
            reset_dut();
            run_serializer_test(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: LSB Only (16'h0001)", test_num);
            reset_dut();
            run_serializer_test(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: MSB Only (16'h8000)", test_num);
            reset_dut();
            run_serializer_test(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Arbitrary Pattern (16'h1234)", test_num);
            reset_dut();
            run_serializer_test(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: IDLE Check", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            in_en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%b, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, in_en, rst, data_out, valid);
    end

endmodule
