`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg rst;
    wire [7:0] doutA;
    wire [7:0] doutB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .doutA(doutA),
        .doutB(doutB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 16'h0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0x0000)", test_num);
            reset_dut();


            din = 16'h0000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (0xFFFF)", test_num);
            reset_dut();

            din = 16'hFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x1234", test_num);
            reset_dut();

            din = 16'h1234;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h12, 8'h34);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0xAAAA", test_num);
            reset_dut();

            din = 16'hAAAA;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0xABCD", test_num);
            reset_dut();

            din = 16'hABCD;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hAB, 8'hCD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x01FE", test_num);
            reset_dut();

            din = 16'h01FE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h01, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Cycles Capture", test_num);
            reset_dut();


            din = 16'h1122;
            @(posedge clk);
            #1;


            din = 16'h3344;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h33, 8'h44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_doutA;
        input [7:0] expected_doutB;
        begin
            if (expected_doutA === (expected_doutA ^ doutA ^ expected_doutA) &&
                expected_doutB === (expected_doutB ^ doutB ^ expected_doutB)) begin
                $display("PASS");
                $display("  Outputs: doutA=%h, doutB=%h",
                         doutA, doutB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doutA=%h, doutB=%h",
                         expected_doutA, expected_doutB);
                $display("  Got:      doutA=%h, doutB=%h",
                         doutA, doutB);
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
        $dumpvars(0,clk, din, rst, doutA, doutB);
    end

endmodule
