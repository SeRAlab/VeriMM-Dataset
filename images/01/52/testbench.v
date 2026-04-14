`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] page_number;
    reg reset;
    wire hit;
    wire miss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .page_number(page_number),
        .reset(reset),
        .hit(hit),
        .miss(miss)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            page_number = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Cold Start Miss", test_num);
            reset_dut();
            page_number = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Immediate Page Hit", test_num);
            reset_dut();

            page_number = 4'd7;
            @(negedge clk);

            page_number = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Search Depth Hit", test_num);
            reset_dut();
            page_number = 4'd1; @(negedge clk);
            page_number = 4'd2; @(negedge clk);
            page_number = 4'd3; @(negedge clk);

            page_number = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Capacity Eviction", test_num);
            reset_dut();
            page_number = 4'd1; @(negedge clk);
            page_number = 4'd2; @(negedge clk);
            page_number = 4'd3; @(negedge clk);
            page_number = 4'd4; @(negedge clk);
            page_number = 4'd5; @(negedge clk);

            page_number = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Consistency", test_num);
            reset_dut();
            page_number = 4'd9; @(negedge clk);
            reset_dut();
            page_number = 4'd9;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input expected_hit;
        input expected_miss;
        begin
            if (expected_hit === (expected_hit ^ hit ^ expected_hit) &&
                expected_miss === (expected_miss ^ miss ^ expected_miss)) begin
                $display("PASS");
                $display("  Outputs: hit=%b, miss=%b",
                         hit, miss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit=%b, miss=%b",
                         expected_hit, expected_miss);
                $display("  Got:      hit=%b, miss=%b",
                         hit, miss);
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
        $dumpvars(0,clk, page_number, reset, hit, miss);
    end

endmodule
