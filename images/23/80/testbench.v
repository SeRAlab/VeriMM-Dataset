`timescale 1ns/1ps

module CacheReplacement_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg policy;
    reg reset;
    wire [1:0] replace_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CacheReplacement dut (
        .addr(addr),
        .clk(clk),
        .policy(policy),
        .reset(reset),
        .replace_index(replace_index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            addr = 4'h0;
            policy = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FIFO Basic Cycle", test_num);
            reset_dut();
            policy = 0;


            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h2; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;
            addr = 4'h4; @(posedge clk); #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FIFO Hit Immunity", test_num);
            reset_dut();
            policy = 0;

            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h2; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;
            addr = 4'h1; @(posedge clk); #1;



            #1;




            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LRU Simple Miss Sequence", test_num);
            reset_dut();
            policy = 1;

            addr = 4'hA; @(posedge clk); #1;
            addr = 4'hB; @(posedge clk); #1;
            addr = 4'hC; @(posedge clk); #1;
            addr = 4'hD; @(posedge clk); #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LRU Hit Updates Victim", test_num);
            reset_dut();
            policy = 1;

            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h2; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;
            addr = 4'h4; @(posedge clk); #1;


            addr = 4'h1; @(posedge clk); #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LRU Multiple Hits", test_num);
            reset_dut();
            policy = 1;

            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h2; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;
            addr = 4'h4; @(posedge clk); #1;

            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FIFO Replacement Wrap", test_num);
            reset_dut();
            policy = 0;

            addr = 4'h1; @(posedge clk); #1;
            addr = 4'h2; @(posedge clk); #1;
            addr = 4'h3; @(posedge clk); #1;
            addr = 4'h4; @(posedge clk); #1;
            addr = 4'h5; @(posedge clk); #1;
            addr = 4'h6; @(posedge clk); #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CacheReplacement Testbench");
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
        input [1:0] expected_replace_index;
        begin
            if (expected_replace_index === (expected_replace_index ^ replace_index ^ expected_replace_index)) begin
                $display("PASS");
                $display("  Outputs: replace_index=%h",
                         replace_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replace_index=%h",
                         expected_replace_index);
                $display("  Got:      replace_index=%h",
                         replace_index);
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
        $dumpvars(0,addr, clk, policy, reset, replace_index);
    end

endmodule
