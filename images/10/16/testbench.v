`timescale 1ns/1ps

module max_heap_tb;

    // Testbench signals (sequential circuit)
    reg insert;
    reg [7:0] insert_value;
    wire [7:0] max_value;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_heap dut (
        .insert(insert),
        .insert_value(insert_value),
        .max_value(max_value),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        insert = 0;
        forever #5 insert = ~insert;
    end

        task reset_dut;

        begin
            rst_n = 0;
            insert = 0;
            insert_value = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task heap_push;

        input [7:0] value;
        begin
            @(posedge clk);
            insert = 1;
            insert_value = value;
            @(posedge clk);
            insert = 0;
            insert_value = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Insertion");
            reset_dut();
            heap_push(8'd50);
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd50, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Ascending Insertion (10, 20, 30)");
            reset_dut();
            heap_push(8'd10);
            heap_push(8'd20);
            heap_push(8'd30);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Descending Insertion (90, 80, 70)");
            reset_dut();
            heap_push(8'd90);
            heap_push(8'd80);
            heap_push(8'd70);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd90, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed Order Insertion");
            reset_dut();
            heap_push(8'd15);
            heap_push(8'd100);
            heap_push(8'd45);
            heap_push(8'd120);
            heap_push(8'd10);
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd120, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Duplicate Values");
            reset_dut();
            heap_push(8'd55);
            heap_push(8'd55);
            heap_push(8'd20);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd55, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Capacity Test (16 elements)");
            reset_dut();
            for (i = 1; i <= 16; i = i + 1) begin
                heap_push(i * 5);
            end
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd80, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_heap Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_max_value;
        input expected_valid;
        begin
            if (expected_max_value === (expected_max_value ^ max_value ^ expected_max_value) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: max_value=%h, valid=%b",
                         max_value, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_value=%h, valid=%b",
                         expected_max_value, expected_valid);
                $display("  Got:      max_value=%h, valid=%b",
                         max_value, valid);
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
        $dumpvars(0,insert, insert_value, max_value, valid);
    end

endmodule
