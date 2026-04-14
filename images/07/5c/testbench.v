`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] head_data;
    reg head_valid;
    reg reset;
    wire [7:0] current_data;
    wire end_of_list;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .head_data(head_data),
        .head_valid(head_valid),
        .reset(reset),
        .current_data(current_data),
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
            head_data = 8'h0;
            head_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start traversal with head data", test_num);
            reset_dut();

            head_data = 8'hA1;
            head_valid = 1;
            @(posedge clk);
            head_valid = 0;


            repeat(1) @(posedge clk);


            #1;



            check_outputs(8'hA1, 0);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Traverse until end_of_list is asserted", test_num);
            reset_dut();

            head_data = 8'h05;
            head_valid = 1;
            @(posedge clk);
            head_valid = 0;

            timeout = 0;

            while (!end_of_list && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
            end



            #1;




            check_outputs(current_data, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle state (no head_valid)", test_num);
            reset_dut();


            repeat(5) @(posedge clk);



            #1;




            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during traversal", test_num);
            reset_dut();

            head_data = 8'hFF;
            head_valid = 1;
            @(posedge clk);
            head_valid = 0;

            repeat(2) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple consecutive traversals", test_num);
            reset_dut();


            head_data = 8'h11;
            head_valid = 1;
            @(posedge clk);
            head_valid = 0;
            while(!end_of_list) @(posedge clk);


            @(posedge clk);
            head_data = 8'h22;
            head_valid = 1;
            @(posedge clk);
            head_valid = 0;

            repeat(1) @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b0);
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
        input [7:0] expected_current_data;
        input expected_end_of_list;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data) &&
                expected_end_of_list === (expected_end_of_list ^ end_of_list ^ expected_end_of_list)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h, end_of_list=%b",
                         current_data, end_of_list);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h, end_of_list=%b",
                         expected_current_data, expected_end_of_list);
                $display("  Got:      current_data=%h, end_of_list=%b",
                         current_data, end_of_list);
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
        $dumpvars(0,clk, head_data, head_valid, reset, current_data, end_of_list);
    end

endmodule
