`timescale 1ns/1ps

module M65C02_MPCv4_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] BA;
    reg Clk;
    reg [3:0] I;
    reg [2:0] MW;
    reg Rst;
    reg [3:0] T;
    reg Wait;
    wire [9:0] MA;
    wire [2:0] MC;
    wire [1:0] Via;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    M65C02_MPCv4 dut (
        .BA(BA),
        .Clk(Clk),
        .I(I),
        .MW(MW),
        .Rst(Rst),
        .T(T),
        .Wait(Wait),
        .MA(MA),
        .MC(MC),
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
            Clk = 0;
            BA = 10'h000;
            I = 4'h0;
            MW = 3'h0;
            T = 4'h0;
            Wait = 0;
            #10;
            Rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();



            #1;




            check_outputs(10'h000, 3'h0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Instruction Fetch (I=1, T=1)", test_num);
            reset_dut();

            @(posedge Clk);
            I = 4'h1;
            T = 4'h1;
            BA = 10'h100;
            MW = 3'h0;
            Wait = 0;

            #5;

            #1;


            check_outputs(10'h101, 3'h1, 2'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Memory Operation (I=5, T=2)", test_num);
            reset_dut();

            @(posedge Clk);
            I = 4'h5;
            T = 4'h2;
            BA = 10'h2A0;
            MW = 3'h2;
            Wait = 0;

            #5;

            #1;


            check_outputs(10'h2A2, 3'h5, 2'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Wait State Activation", test_num);
            reset_dut();

            @(posedge Clk);
            I = 4'h8;
            T = 4'h4;
            BA = 10'h050;
            Wait = 1;

            #5;


            #1;



            check_outputs(10'h054, 3'h0, 2'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: High Address Range (I=F, T=7)", test_num);
            reset_dut();

            @(posedge Clk);
            I = 4'hF;
            T = 4'h7;
            BA = 10'h3F8;
            MW = 3'h7;
            Wait = 0;

            #5;

            #1;


            check_outputs(10'h3FF, 3'h7, 2'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Memory Write Data Check", test_num);
            reset_dut();

            @(posedge Clk);
            I = 4'h3;
            T = 4'h1;
            BA = 10'h010;
            MW = 3'h4;
            Wait = 0;

            #5;

            #1;


            check_outputs(10'h011, 3'h3, 2'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("M65C02_MPCv4 Testbench");
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
        input [9:0] expected_MA;
        input [2:0] expected_MC;
        input [1:0] expected_Via;
        begin
            if (expected_MA === (expected_MA ^ MA ^ expected_MA) &&
                expected_MC === (expected_MC ^ MC ^ expected_MC) &&
                expected_Via === (expected_Via ^ Via ^ expected_Via)) begin
                $display("PASS");
                $display("  Outputs: MA=%h, MC=%h, Via=%h",
                         MA, MC, Via);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MA=%h, MC=%h, Via=%h",
                         expected_MA, expected_MC, expected_Via);
                $display("  Got:      MA=%h, MC=%h, Via=%h",
                         MA, MC, Via);
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
        $dumpvars(0,BA, Clk, I, MW, Rst, T, Wait, MA, MC, Via);
    end

endmodule
