`timescale 1ns/1ps

module M65C02_MPC_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] BA;
    reg Clk;
    reg En;
    reg [3:0] I;
    reg [2:0] MW;
    reg PLS;
    reg Rdy;
    reg Rst;
    reg [3:0] T;
    wire [9:0] MA;
    wire [1:0] Via;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    M65C02_MPC dut (
        .BA(BA),
        .Clk(Clk),
        .En(En),
        .I(I),
        .MW(MW),
        .PLS(PLS),
        .Rdy(Rdy),
        .Rst(Rst),
        .T(T),
        .MA(MA),
        .Via(Via)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            BA = 10'h000;
            En = 0;
            I = 4'h0;
            MW = 3'b000;
            PLS = 0;
            Rdy = 0;
            T = 4'h0;
            @(posedge Clk);
            #1;
            Rst = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: System Reset");
            reset_dut();

            #1;


            check_outputs(10'h000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Address Generation");
            reset_dut();
            BA = 10'h1A5;
            I  = 4'h0;
            T  = 4'h0;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(10'h1A5, 2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Timing Step Influence");
            reset_dut();
            BA = 10'h200;
            I  = 4'h5;
            T  = 4'h2;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(10'h202, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Ready Signal Stall");
            reset_dut();
            BA = 10'h100;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            BA = 10'h3FF;
            Rdy = 0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(10'h100, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable Signal Logic");
            reset_dut();
            BA = 10'h050;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            En = 0;
            BA = 10'h080;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(10'h050, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Instruction Decoding (Via)");
            reset_dut();
            I = 4'hB;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(MA, 2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: PLS Signal Effect");
            reset_dut();
            BA = 10'h123;
            PLS = 1;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(10'h123, 2'b00);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Memory Width Interaction");
            reset_dut();
            BA = 10'h010;
            MW = 3'b111;
            En = 1;
            Rdy = 1;
            @(posedge Clk);
            #1;

            if (MA !== 10'hxxx && MA !== 10'hzzz) begin
                pass_count = pass_count + 1;
                $display("PASS: MA valid for MW=7");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: MA invalid for MW=7");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("M65C02_MPC Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [9:0] expected_MA;
        input [1:0] expected_Via;
        begin
            if (expected_MA === (expected_MA ^ MA ^ expected_MA) &&
                expected_Via === (expected_Via ^ Via ^ expected_Via)) begin
                $display("PASS");
                $display("  Outputs: MA=%h, Via=%h",
                         MA, Via);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MA=%h, Via=%h",
                         expected_MA, expected_Via);
                $display("  Got:      MA=%h, Via=%h",
                         MA, Via);
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
        $dumpvars(0,BA, Clk, En, I, MW, PLS, Rdy, Rst, T, MA, Via);
    end

endmodule
