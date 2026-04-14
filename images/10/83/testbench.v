`timescale 1ns/1ps

module cache_memory_tb;

    // Testbench signals (sequential circuit)
    reg access;
    reg [7:0] addr;
    reg clk;
    reg reset;
    wire [7:0] cache_line0;
    wire [7:0] cache_line1;
    wire [7:0] cache_line2;
    wire [7:0] cache_line3;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_memory dut (
        .access(access),
        .addr(addr),
        .clk(clk),
        .reset(reset),
        .cache_line0(cache_line0),
        .cache_line1(cache_line1),
        .cache_line2(cache_line2),
        .cache_line3(cache_line3),
        .hit(hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            access = 0;
            addr = 8'h00;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial Reset State");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Access Fill");
            test_num = test_num + 1;
            reset_dut();

            addr = 8'hAA;
            access = 1;
            @(posedge clk);
            #1 access = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 8'h00, 8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Full Cache Fill");
            test_num = test_num + 1;
            reset_dut();


            addr = 8'h11; access = 1; @(posedge clk); #1;
            addr = 8'h22; access = 1; @(posedge clk); #1;
            addr = 8'h33; access = 1; @(posedge clk); #1;
            addr = 8'h44; access = 1; @(posedge clk); #1 access = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h11, 8'h22, 8'h33, 8'h44, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Cache Hit Detection");
            test_num = test_num + 1;
            reset_dut();


            addr = 8'h01; access = 1; @(posedge clk); #1;

            addr = 8'h01; access = 1; @(posedge clk); #1 access = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h01, 8'h00, 8'h00, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Capacity Replacement");
            test_num = test_num + 1;
            reset_dut();


            addr = 8'h10; access = 1; @(posedge clk); #1;
            addr = 8'h20; access = 1; @(posedge clk); #1;
            addr = 8'h30; access = 1; @(posedge clk); #1;
            addr = 8'h40; access = 1; @(posedge clk); #1;

            addr = 8'h50; access = 1; @(posedge clk); #1 access = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h50, 8'h20, 8'h30, 8'h40, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: LRU Specific Update");
            test_num = test_num + 1;
            reset_dut();

            addr = 8'h01; access = 1; @(posedge clk); #1;
            addr = 8'h02; access = 1; @(posedge clk); #1;
            addr = 8'h03; access = 1; @(posedge clk); #1;
            addr = 8'h04; access = 1; @(posedge clk); #1;


            addr = 8'h01; access = 1; @(posedge clk); #1;


            addr = 8'h05; access = 1; @(posedge clk); #1 access = 0;
            @(posedge clk);



            #1;




            check_outputs(8'h01, 8'h05, 8'h03, 8'h04, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_memory Testbench");
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
        input [7:0] expected_cache_line0;
        input [7:0] expected_cache_line1;
        input [7:0] expected_cache_line2;
        input [7:0] expected_cache_line3;
        input expected_hit;
        begin
            if (expected_cache_line0 === (expected_cache_line0 ^ cache_line0 ^ expected_cache_line0) &&
                expected_cache_line1 === (expected_cache_line1 ^ cache_line1 ^ expected_cache_line1) &&
                expected_cache_line2 === (expected_cache_line2 ^ cache_line2 ^ expected_cache_line2) &&
                expected_cache_line3 === (expected_cache_line3 ^ cache_line3 ^ expected_cache_line3) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: cache_line0=%h, cache_line1=%h, cache_line2=%h, cache_line3=%h, hit=%b",
                         cache_line0, cache_line1, cache_line2, cache_line3, hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_line0=%h, cache_line1=%h, cache_line2=%h, cache_line3=%h, hit=%b",
                         expected_cache_line0, expected_cache_line1, expected_cache_line2, expected_cache_line3, expected_hit);
                $display("  Got:      cache_line0=%h, cache_line1=%h, cache_line2=%h, cache_line3=%h, hit=%b",
                         cache_line0, cache_line1, cache_line2, cache_line3, hit);
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
        $dumpvars(0,access, addr, clk, reset, cache_line0, cache_line1, cache_line2, cache_line3, hit);
    end

endmodule
