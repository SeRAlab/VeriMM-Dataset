`timescale 1ns/1ps

module M65C02_MPCv3_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] BA;
    reg Clk;
    reg [3:0] I;
    reg [2:0] MW;
    reg Rst;
    reg [3:0] T;
    reg Wait;
    reg [1:0] uLen;
    wire [9:0] MA;
    wire [1:0] MC;
    wire [1:0] Via;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    M65C02_MPCv3 dut (
        .BA(BA),
        .Clk(Clk),
        .I(I),
        .MW(MW),
        .Rst(Rst),
        .T(T),
        .Wait(Wait),
        .uLen(uLen),
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
            BA = 0;
            I = 0;
            MW = 0;
            T = 0;
            Wait = 0;
            uLen = 0;
            @(posedge Clk);
            #1 Rst = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();


            #1;



            check_outputs(10'h000, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MC Increment", test_num);
            reset_dut();

            uLen = 2'b10;
            BA = 10'h100;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(10'h100, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wait State Persistence", test_num);
            reset_dut();

            uLen = 2'b11;
            BA = 10'h055;
            Wait = 1;
            @(posedge Clk);
            @(posedge Clk);
            #1;


            #1;



            check_outputs(10'h055, 2'b00, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Instruction and BA Update", test_num);
            reset_dut();

            BA = 10'h3FF;
            I = 4'hA;
            MW = 3'b001;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(10'h3FF, 2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MC Rollover", test_num);
            reset_dut();

            uLen = 2'b01;
            BA = 10'h123;
            @(posedge Clk);
            @(posedge Clk);
            #1;


            #1;



            check_outputs(10'h123, 2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Branch Condition Handling", test_num);
            reset_dut();

            BA = 10'h200;
            T = 4'b1111;
            I = 4'h5;
            @(posedge Clk);
            #1;



            #1;




            check_outputs(10'h200, 2'b01, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("M65C02_MPCv3 Testbench");
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
        input [1:0] expected_MC;
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
        $dumpvars(0,BA, Clk, I, MW, Rst, T, Wait, uLen, MA, MC, Via);
    end

endmodule
