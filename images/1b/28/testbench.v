`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] head;
    reg reset;
    wire [31:0] current_value;
    wire done;

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
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            head = 32'hFFFFFFFF;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Standard List Traversal", test_num);
            reset_dut();


            head = 32'd0;


            fork : wait_for_done
                begin
                    wait(done === 1'b1);
                    disable wait_for_done;
                end
                begin
                    repeat (100) @(posedge clk);
                    $display("Timeout waiting for done signal");
                    disable wait_for_done;
                end
            join


            #1;



            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Empty List (Head = -1)", test_num);
            reset_dut();


            head = 32'hFFFFFFFF;


            repeat (2) @(posedge clk);


            #1;



            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Single Node List", test_num);
            reset_dut();

            head = 32'd10;


            fork : wait_for_done_single
                begin
                    wait(done === 1'b1);
                    disable wait_for_done_single;
                end
                begin
                    repeat (10) @(posedge clk);
                    disable wait_for_done_single;
                end
            join

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Mid-way Reset", test_num);
            reset_dut();

            head = 32'd0;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            #(15);
            reset = 0;
            head = 32'hFFFFFFFF;

            @(posedge clk);

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
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
        input [31:0] expected_current_value;
        input expected_done;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, done=%b",
                         current_value, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, done=%b",
                         expected_current_value, expected_done);
                $display("  Got:      current_value=%h, done=%b",
                         current_value, done);
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
        $dumpvars(0,clk, head, reset, current_value, done);
    end

endmodule
