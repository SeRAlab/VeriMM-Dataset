`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] head;
    reg reset;
    wire [7:0] current_value;
    wire end_of_list;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .head(head),
        .reset(reset),
        .current_value(current_value),
        .end_of_list(end_of_list)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal 3-node traversal", test_num);
            head = 8'h10;
            reset_dut();



            repeat(4) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Empty list (Head = 0x00)", test_num);
            head = 8'h00;
            reset_dut();


            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single node list (Head = 0xA0)", test_num);
            head = 8'hA0;
            reset_dut();


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mid-traversal check (3-node list)", test_num);
            head = 8'h10;
            reset_dut();


            repeat(1) @(posedge clk);
            #1;



            if (end_of_list === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Still traversing as expected.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Premature end_of_list signal.");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset during traversal", test_num);
            head = 8'h10;
            reset_dut();

            repeat(2) @(posedge clk);


            head = 8'h55;
            reset_dut();


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_current_value;
        input expected_end_of_list;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_end_of_list === (expected_end_of_list ^ end_of_list ^ expected_end_of_list)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, end_of_list=%b",
                         current_value, end_of_list);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, end_of_list=%b",
                         expected_current_value, expected_end_of_list);
                $display("  Got:      current_value=%h, end_of_list=%b",
                         current_value, end_of_list);
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
        $dumpvars(0,clk, head, reset, current_value, end_of_list);
    end

endmodule
