`timescale 1ns/1ps

module AStar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] cost_function;
    reg [3:0] current_node;
    reg [3:0] heuristic_function;
    reg reset;
    reg [3:0] target_node;
    wire [3:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStar dut (
        .clk(clk),
        .cost_function(cost_function),
        .current_node(current_node),
        .heuristic_function(heuristic_function),
        .reset(reset),
        .target_node(target_node),
        .next_node(next_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cost_function = 0;
            current_node = 0;
            heuristic_function = 0;
            target_node = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Node Evaluation", test_num);
            reset_dut();

            target_node = 4'hA;
            current_node = 4'h5;
            cost_function = 4'h2;
            heuristic_function = 4'h3;

            @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Lower f(n) Selection", test_num);
            reset_dut();

            target_node = 4'hF;


            current_node = 4'h1;
            cost_function = 4'h4;
            heuristic_function = 4'h6;
            @(posedge clk);


            #1 current_node = 4'h2;
            cost_function = 4'h2;
            heuristic_function = 4'h3;
            @(posedge clk);

            #1 #1;
 check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Ignore Higher f(n)", test_num);
            reset_dut();

            target_node = 4'hF;


            current_node = 4'hA;
            cost_function = 4'h1;
            heuristic_function = 4'h1;
            @(posedge clk);


            #1 current_node = 4'hB;
            cost_function = 4'h8;
            heuristic_function = 4'h7;
            @(posedge clk);

            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Target Node Reached", test_num);
            reset_dut();

            target_node = 4'hE;


            current_node = 4'h3;
            cost_function = 4'h5;
            heuristic_function = 4'h5;
            @(posedge clk);


            #1 current_node = 4'hE;
            cost_function = 4'h8;
            heuristic_function = 4'h0;
            @(posedge clk);

            #1 #1;
 check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStar Testbench");
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
        input [3:0] expected_next_node;
        begin
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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
        $dumpvars(0,clk, cost_function, current_node, heuristic_function, reset, target_node, next_node);
    end

endmodule
