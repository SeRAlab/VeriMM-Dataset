`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] message;
    reg rst;
    wire done;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .done(done),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = All Zeros", test_num);
            reset_dut();

            message = 256'h0;


            wait(done === 1'b1);


            @(posedge clk);



            #1;




            check_outputs(1'b1, 256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = All Ones", test_num);
            reset_dut();

            message = {256{1'b1}};

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h95f00e5720d20d750c8227096d88b4d8d1e2e987c262704a434199859f518e38);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = Alternating Pattern (0101...)", test_num);
            reset_dut();

            message = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hb6628c6819446d3f2347101736142790696b99ec76f1e843b02213d52723793f);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = Incremental Bytes", test_num);
            reset_dut();

            message = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h23b88591325178303f56f6f9f36f9036a18d37452e82506b3f71c93a8e94589d);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Operation", test_num);


            reset_dut();
            message = 256'hABCDEFAABBCCDDEEFF00112233445566778899AABBCCDDEEFF00112233445566;


            repeat(10) @(posedge clk);


            $display("  Triggering asynchronous reset...");
            rst = 1;
            #20;
            rst = 0;


            message = 256'h1234567812345678123456781234567812345678123456781234567812345678;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h0247656d02873155899479e0a2947171e220e82c5567368686d87a419c8d3393);
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
        input expected_done;
        input [255:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, message, rst, done, hash);
    end

endmodule
