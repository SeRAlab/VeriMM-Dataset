`timescale 1ns/1ps

module ramDualPort_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addrA;
    reg [7:0] addrB;
    reg clk;
    reg [7:0] dataA;
    reg [7:0] dataB;
    reg weA;
    reg weB;
    wire [7:0] qA;
    wire [7:0] qB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ramDualPort dut (
        .addrA(addrA),
        .addrB(addrB),
        .clk(clk),
        .dataA(dataA),
        .dataB(dataB),
        .weA(weA),
        .weB(weB),
        .qA(qA),
        .qB(qB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addrA = 0;
            addrB = 0;
            dataA = 0;
            dataB = 0;
            weA = 0;
            weB = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Port A Simple Write and Read", test_num);


            addrA = 8'h10;
            dataA = 8'hA5;
            weA = 1;
            @(posedge clk);
            #1;
            weA = 0;


            addrA = 8'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Port B Simple Write and Read", test_num);


            addrB = 8'h20;
            dataB = 8'h5A;
            weB = 1;
            @(posedge clk);
            #1;
            weB = 0;


            addrB = 8'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Simultaneous Writes to Different Addresses", test_num);


            addrA = 8'h30; dataA = 8'h33; weA = 1;
            addrB = 8'h40; dataB = 8'h44; weB = 1;
            @(posedge clk);
            #1;
            weA = 0; weB = 0;


            addrA = 8'h30;
            addrB = 8'h40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33, 8'h44);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Simultaneous Reads from Same Address", test_num);


            addrA = 8'h50; dataA = 8'hFF; weA = 1;
            @(posedge clk);
            #1;
            weA = 0;


            addrA = 8'h50;
            addrB = 8'h50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Cross-Port Access", test_num);


            addrB = 8'h60; dataB = 8'hCC; weB = 1;
            @(posedge clk);
            #1;
            weB = 0;


            addrA = 8'h60;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Simultaneous Write and Read", test_num);


            addrA = 8'h70; dataA = 8'h77; weA = 1;
            @(posedge clk);
            #1;


            addrA = 8'h80; dataA = 8'h88; weA = 1;
            addrB = 8'h70; weB = 0;
            @(posedge clk);
            #1;
            weA = 0;




            #1;





            check_outputs(qA, 8'h77);


            addrA = 8'h80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h88, qB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ramDualPort Testbench");
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
        input [7:0] expected_qA;
        input [7:0] expected_qB;
        begin
            if (expected_qA === (expected_qA ^ qA ^ expected_qA) &&
                expected_qB === (expected_qB ^ qB ^ expected_qB)) begin
                $display("PASS");
                $display("  Outputs: qA=%h, qB=%h",
                         qA, qB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qA=%h, qB=%h",
                         expected_qA, expected_qB);
                $display("  Got:      qA=%h, qB=%h",
                         qA, qB);
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
        $dumpvars(0,addrA, addrB, clk, dataA, dataB, weA, weB, qA, qB);
    end

endmodule
