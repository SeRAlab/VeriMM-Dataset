`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ackA;
    reg ackB;
    reg clk;
    reg [7:0] dataIn;
    reg reqA;
    reg reqB;
    reg rst;
    wire [7:0] dataOutA;
    wire [7:0] dataOutB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ackA(ackA),
        .ackB(ackB),
        .clk(clk),
        .dataIn(dataIn),
        .reqA(reqA),
        .reqB(reqB),
        .rst(rst),
        .dataOutA(dataOutA),
        .dataOutB(dataOutB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            reqA = 0;
            reqB = 0;
            ackA = 0;
            ackB = 0;
            dataIn = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Channel A Transfer", test_num);
            reset_dut();

            @(negedge clk);
            reqA = 1;
            ackA = 1;
            dataIn = 8'hA1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA1, 8'h00);


            reqA = 0;
            ackA = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Channel B Transfer", test_num);
            reset_dut();

            @(negedge clk);
            reqB = 1;
            ackB = 1;
            dataIn = 8'hB2;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'hB2);


            reqB = 0;
            ackB = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Priority Test (A over B)", test_num);
            reset_dut();

            @(negedge clk);
            reqA = 1;
            reqB = 1;
            ackA = 1;
            ackB = 1;
            dataIn = 8'hC3;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hC3, 8'h00);

            reqA = 0;
            ackA = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential Channel Transfers", test_num);
            reset_dut();


            @(negedge clk);
            reqA = 1; ackA = 1; dataIn = 8'h11;
            @(posedge clk);
            #1 reqA = 0; ackA = 0;


            @(negedge clk);
            reqB = 1; ackB = 1; dataIn = 8'h22;
            @(posedge clk);
            #1 reqB = 0; ackB = 0;

            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Req without Ack (No Transfer)", test_num);
            reset_dut();

            @(negedge clk);
            reqA = 1;
            ackA = 0;
            dataIn = 8'hFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();


            @(negedge clk);
            reqA = 1; ackA = 1; dataIn = 8'h55;
            @(posedge clk);


            #1 reqA = 0; ackA = 0; dataIn = 8'h00;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(8'h55, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_dataOutA;
        input [7:0] expected_dataOutB;
        begin
            if (expected_dataOutA === (expected_dataOutA ^ dataOutA ^ expected_dataOutA) &&
                expected_dataOutB === (expected_dataOutB ^ dataOutB ^ expected_dataOutB)) begin
                $display("PASS");
                $display("  Outputs: dataOutA=%h, dataOutB=%h",
                         dataOutA, dataOutB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOutA=%h, dataOutB=%h",
                         expected_dataOutA, expected_dataOutB);
                $display("  Got:      dataOutA=%h, dataOutB=%h",
                         dataOutA, dataOutB);
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
        $dumpvars(0,ackA, ackB, clk, dataIn, reqA, reqB, rst, dataOutA, dataOutB);
    end

endmodule
