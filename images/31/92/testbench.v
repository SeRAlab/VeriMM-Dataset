`timescale 1ns/1ps

module cache_tb;

    // Testbench signals (sequential circuit)
    reg access;
    reg [3:0] address;
    reg clk;
    reg reset;
    wire [3:0] cache_out;
    wire hit;
    wire [3:0] replacement_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache dut (
        .access(access),
        .address(address),
        .clk(clk),
        .reset(reset),
        .cache_out(cache_out),
        .hit(hit),
        .replacement_address(replacement_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            access = 0;
            address = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cold Miss", test_num);
            reset_dut();

            @(posedge clk);
            access = 1;
            address = 4'hA;
            @(posedge clk);
            access = 0;


            #1;



            check_outputs(4'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cache Hit", test_num);
            reset_dut();


            @(posedge clk);
            access = 1;
            address = 4'h5;
            @(posedge clk);


            address = 4'h5;
            @(posedge clk);
            access = 0;


            #1;



            check_outputs(4'h5, 1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Replacement Logic (Capacity Miss)", test_num);
            reset_dut();


            @(posedge clk); access = 1; address = 4'h1;
            @(posedge clk); address = 4'h2;
            @(posedge clk); address = 4'h3;
            @(posedge clk); address = 4'h4;


            @(posedge clk); address = 4'h5;
            @(posedge clk); access = 0;


            #1;



            check_outputs(4'h0, 1'b0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Update", test_num);
            reset_dut();


            @(posedge clk); access = 1; address = 4'h1;
            @(posedge clk); address = 4'h2;
            @(posedge clk); address = 4'h3;


            @(posedge clk); address = 4'h1;


            @(posedge clk); address = 4'h4;




            @(posedge clk); address = 4'h5;
            @(posedge clk); access = 0;


            #1;



            check_outputs(4'h0, 1'b0, 4'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache Testbench");
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
        input [3:0] expected_cache_out;
        input expected_hit;
        input [3:0] expected_replacement_address;
        begin
            if (expected_cache_out === (expected_cache_out ^ cache_out ^ expected_cache_out) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit) &&
                expected_replacement_address === (expected_replacement_address ^ replacement_address ^ expected_replacement_address)) begin
                $display("PASS");
                $display("  Outputs: cache_out=%h, hit=%b, replacement_address=%h",
                         cache_out, hit, replacement_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_out=%h, hit=%b, replacement_address=%h",
                         expected_cache_out, expected_hit, expected_replacement_address);
                $display("  Got:      cache_out=%h, hit=%b, replacement_address=%h",
                         cache_out, hit, replacement_address);
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
        $dumpvars(0,access, address, clk, reset, cache_out, hit, replacement_address);
    end

endmodule
