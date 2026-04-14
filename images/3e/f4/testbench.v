`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] message;
    reg reset;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            message = 64'h0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros", test_num);
            reset_dut();
            message = 64'h0000000000000000;


            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h69871fc357492c13d72b64a275210137);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Hex Sequence", test_num);
            reset_dut();
            message = 64'h0123456789ABCDEF;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h0587d6051515233c84668705a7698e6d);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Ones", test_num);
            reset_dut();
            message = 64'hFFFFFFFFFFFFFFFF;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h011409f0ac31a02796e95c1a70440785);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Alternating Bits (5A)", test_num);
            reset_dut();
            message = 64'h5A5A5A5A5A5A5A5A;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h203f39386c757c2105e1972179836968);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Deadbeef Cafebabe", test_num);
            reset_dut();
            message = 64'hDEADBEEFCAFEBABE;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h0e86a9f776269661f7d0596395b1219b);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: MSB Only", test_num);
            reset_dut();
            message = 64'h8000000000000000;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h4c61df43d46387060f643f809930f78c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, message, reset, hash);
    end

endmodule
