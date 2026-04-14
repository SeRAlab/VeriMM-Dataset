`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] next_node_address;
    reg [7:0] node_data;
    reg reset;
    wire [7:0] current_data;
    wire [7:0] next_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .next_node_address(next_node_address),
        .node_data(node_data),
        .reset(reset),
        .current_data(current_data),
        .next_address(next_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            node_data = 0;
            next_node_address = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Node Load", test_num);
            reset_dut();

            node_data = 8'hA1;
            next_node_address = 8'h10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA1, 8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-node Traversal Sequence", test_num);
            reset_dut();


            node_data = 8'hB1;
            next_node_address = 8'h20;
            @(posedge clk);


            #1;
            node_data = 8'hC2;
            next_node_address = 8'h30;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hC2, 8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: End of List (Null Pointer)", test_num);
            reset_dut();


            node_data = 8'hFF;
            next_node_address = 8'h00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Data Values", test_num);
            reset_dut();

            node_data = 8'hFF;
            next_node_address = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Persistence", test_num);
            reset_dut();

            node_data = 8'h55;
            next_node_address = 8'hAA;
            @(posedge clk);


            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55, 8'hAA);
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
        input [7:0] expected_current_data;
        input [7:0] expected_next_address;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data) &&
                expected_next_address === (expected_next_address ^ next_address ^ expected_next_address)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h, next_address=%h",
                         current_data, next_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h, next_address=%h",
                         expected_current_data, expected_next_address);
                $display("  Got:      current_data=%h, next_address=%h",
                         current_data, next_address);
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
        $dumpvars(0,clk, next_node_address, node_data, reset, current_data, next_address);
    end

endmodule
