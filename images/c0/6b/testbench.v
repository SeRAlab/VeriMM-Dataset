`timescale 1ns/1ps

module SPIxIF_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg DAV;
    reg LSB;
    reg MISO;
    reg [1:0] Mode;
    reg [2:0] Rate;
    reg Rst;
    reg [8:0] TD;
    wire FRE;
    wire FWE;
    wire MOSI;
    wire [7:0] RD;
    wire SCK;
    wire SS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SPIxIF dut (
        .Clk(Clk),
        .DAV(DAV),
        .LSB(LSB),
        .MISO(MISO),
        .Mode(Mode),
        .Rate(Rate),
        .Rst(Rst),
        .TD(TD),
        .FRE(FRE),
        .FWE(FWE),
        .MOSI(MOSI),
        .RD(RD),
        .SCK(SCK),
        .SS(SS)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            DAV = 0;
            LSB = 0;
            MISO = 0;
            Mode = 0;
            Rate = 0;
            TD = 0;
            #20;
            Rst = 0;
            #20;
        end
        endtask
    task simulate_miso;

        input [7:0] data_to_receive;
        input is_lsb_first;
        input spi_mode;
        integer i;
        begin

            wait(SS == 0);
            for (i = 0; i < 8; i = i + 1) begin



                if (Mode == 2'b00 || Mode == 2'b11)
                    @(negedge SCK);
                else
                    @(posedge SCK);

                if (is_lsb_first)
                    MISO = data_to_receive[i];
                else
                    MISO = data_to_receive[7-i];
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            LSB = 0;
            Mode = 2'b00;
            Rate = 3'b000;
            TD = 9'h0A5;

            fork
                begin
                    @(posedge Clk);
                    DAV = 1;
                    @(posedge Clk);
                    DAV = 0;
                end
                simulate_miso(8'h5A, 0, Mode);
            join


            wait(FWE == 1);
            @(posedge Clk);


            #1;



            check_outputs(0, 1, 1, 8'h5A, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            LSB = 1;
            Mode = 2'b11;
            Rate = 3'b001;
            TD = 9'h03C;

            fork
                begin
                    @(posedge Clk);
                    DAV = 1;
                    @(posedge Clk);
                    DAV = 0;
                end
                simulate_miso(8'hC3, 1, Mode);
            join

            wait(FWE == 1);
            @(posedge Clk);


            #1;



            check_outputs(0, 1, 0, 8'hC3, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            LSB = 0;
            Mode = 2'b01;
            Rate = 3'b010;
            TD = 9'h1FF;

            fork
                begin
                    @(posedge Clk);
                    DAV = 1;
                    @(posedge Clk);
                    DAV = 0;
                end
                simulate_miso(8'hAA, 0, Mode);
            join

            wait(FWE == 1);
            @(posedge Clk);


            #1;



            check_outputs(0, 1, 1, 8'hAA, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LSB = 0;
            Mode = 2'b10;
            Rate = 3'b000;
            TD = 9'h000;

            fork
                begin
                    @(posedge Clk);
                    DAV = 1;
                    @(posedge Clk);
                    DAV = 0;
                end
                simulate_miso(8'h00, 0, Mode);
            join

            wait(FWE == 1);
            @(posedge Clk);

            #1;


            check_outputs(0, 1, 0, 8'h00, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SPIxIF Testbench");
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
        input expected_FRE;
        input expected_FWE;
        input expected_MOSI;
        input [7:0] expected_RD;
        input expected_SCK;
        input expected_SS;
        begin
            if (expected_FRE === (expected_FRE ^ FRE ^ expected_FRE) &&
                expected_FWE === (expected_FWE ^ FWE ^ expected_FWE) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_RD === (expected_RD ^ RD ^ expected_RD) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK) &&
                expected_SS === (expected_SS ^ SS ^ expected_SS)) begin
                $display("PASS");
                $display("  Outputs: FRE=%b, FWE=%b, MOSI=%b, RD=%h, SCK=%b, SS=%b",
                         FRE, FWE, MOSI, RD, SCK, SS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FRE=%b, FWE=%b, MOSI=%b, RD=%h, SCK=%b, SS=%b",
                         expected_FRE, expected_FWE, expected_MOSI, expected_RD, expected_SCK, expected_SS);
                $display("  Got:      FRE=%b, FWE=%b, MOSI=%b, RD=%h, SCK=%b, SS=%b",
                         FRE, FWE, MOSI, RD, SCK, SS);
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
        $dumpvars(0,Clk, DAV, LSB, MISO, Mode, Rate, Rst, TD, FRE, FWE, MOSI, RD, SCK, SS);
    end

endmodule
