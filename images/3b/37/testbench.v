`timescale 1ns/1ps

module dfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_node;
    reg reset;
    reg [7:0] target_value;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs dut (
        .clk(clk),
        .current_node(current_node),
        .reset(reset),
        .target_value(target_value),
        .found(found)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_node = 8'h00;
            target_value = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target at Root", test_num);
            reset_dut();

            target_value = 8'd15;
            current_node = 8'd15;

            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target in middle of DFS sequence", test_num);
            reset_dut();

            target_value = 8'd42;


            current_node = 8'd10; @(posedge clk);
            current_node = 8'd20; @(posedge clk);
            current_node = 8'd42; @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target not found", test_num);
            reset_dut();

            target_value = 8'd99;


            current_node = 8'd01; @(posedge clk);
            current_node = 8'd02; @(posedge clk);
            current_node = 8'd03; @(posedge clk);
            current_node = 8'd04; @(posedge clk);
            current_node = 8'd05; @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Found signal persistence", test_num);
            reset_dut();

            target_value = 8'd7;
            current_node = 8'd7;  @(posedge clk);
            current_node = 8'd10; @(posedge clk);
            current_node = 8'd12; @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset after found", test_num);


            reset_dut();
            target_value = 8'd5;
            current_node = 8'd5;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            current_node = 8'd20;
            target_value = 8'd5;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target value zero", test_num);
            reset_dut();

            target_value = 8'h00;
            current_node = 8'hFF; @(posedge clk);
            current_node = 8'h00; @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs Testbench");
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
        input expected_found;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
        $dumpvars(0,clk, current_node, reset, target_value, found);
    end

endmodule
