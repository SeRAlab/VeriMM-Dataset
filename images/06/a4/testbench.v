`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            data_in = 5'b0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);

            @(posedge clk);
            data_in <= 5'b00000;


            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);

            @(posedge clk);
            data_in <= 5'b11111;

            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 01010", test_num);

            @(posedge clk);
            data_in <= 5'b01010;

            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 10101", test_num);

            @(posedge clk);
            data_in <= 5'b10101;

            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 11001", test_num);

            @(posedge clk);
            data_in <= 5'b11001;

            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Flow Stress", test_num);




            @(posedge clk);
            data_in <= 5'b00011;

            @(posedge clk);
            data_in <= 5'b11100;

            @(posedge clk);
            data_in <= 5'b00000;

            @(posedge clk);
            #2;
            $display("Checking Result for Input A...");
            #1;

            check_outputs(5'b10100);

            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Checking Result for Input B...");
            #1;

            check_outputs(5'b00001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
