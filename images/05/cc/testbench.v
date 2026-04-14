`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] head;
    reg rst;
    reg traverse;
    wire [4:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .head(head),
        .rst(rst),
        .traverse(traverse),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            traverse = 0;
            head = 5'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify initialization to head value", test_num);
            reset_dut();
            head = 5'h05;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify single-step traversal", test_num);
            reset_dut();
            head = 5'h0A;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);
            traverse = 1;
            @(posedge clk);
            #1 traverse = 0;
            @(posedge clk);

            #1;


            check_outputs(5'h0B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify multi-step traversal (3 steps)", test_num);
            reset_dut();
            head = 5'h01;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);

            repeat(3) begin
                traverse = 1;
                @(posedge clk);
                #1 traverse = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(5'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify no movement when traverse is 0", test_num);
            reset_dut();
            head = 5'h07;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);
            traverse = 0;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(5'h07);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify mid-traversal reset returns to head", test_num);
            reset_dut();
            head = 5'h02;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);
            traverse = 1; @(posedge clk); #1 traverse = 0; @(posedge clk);


            head = 5'h10;
            rst = 1; @(posedge clk); #1 rst = 0;
            @(posedge clk);

            #1;


            check_outputs(5'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [4:0] expected_current_value;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h",
                         current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h",
                         expected_current_value);
                $display("  Got:      current_value=%h",
                         current_value);
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
        $dumpvars(0,clk, head, rst, traverse, current_value);
    end

endmodule
