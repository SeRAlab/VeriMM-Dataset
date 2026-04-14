`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg data_valid;
    reg rst;
    wire [255:0] hash_out;
    wire hash_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .hash_out(hash_out),
        .hash_ready(hash_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 256'b0;
            data_valid = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();

            data_in = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            wait(hash_ready === 1'b1);


            #1;



            check_outputs(256'h3361a72d3f47e30777e5e31e505193f18e806198f310f8a9a4731f907e8523c9, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            reset_dut();

            data_in = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            wait(hash_ready === 1'b1);


            #1;



            check_outputs(256'hef034789547d9539f9922e37452d3a68393c3c1ed67011f07f59d5830b80f12a, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Hex Pattern", test_num);
            reset_dut();

            data_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            wait(hash_ready === 1'b1);


            #1;



            check_outputs(256'h0443216834d0b04b9c1d1d86d52575f0a3e87834220b2f90a424e4c29759e51c, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Input", test_num);
            reset_dut();

            data_in = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            wait(hash_ready === 1'b1);


            #1;



            check_outputs(256'h953f66903274296716f2c385b2170362f689f5064eb9856d68f643198031313a, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ASCII String Input", test_num);
            reset_dut();


            data_in = "Verilog_SHA256_Test_Vector_Input";
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            wait(hash_ready === 1'b1);

            #1;


            check_outputs(256'h7790895393b469146030588647008f1b181284f3e6027a69b7f5255478d91012, 1'b1);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
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
        input [255:0] expected_hash_out;
        input expected_hash_ready;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_hash_ready === (expected_hash_ready ^ hash_ready ^ expected_hash_ready)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h, hash_ready=%b",
                         hash_out, hash_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h, hash_ready=%b",
                         expected_hash_out, expected_hash_ready);
                $display("  Got:      hash_out=%h, hash_ready=%b",
                         hash_out, hash_ready);
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
        $dumpvars(0,clk, data_in, data_valid, rst, hash_out, hash_ready);
    end

endmodule
