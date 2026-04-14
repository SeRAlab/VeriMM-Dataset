`timescale 1ns/1ps

module pwmregister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pwmldce;
    reg [7:0] wrtdata;
    wire [7:0] pwmval;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pwmregister dut (
        .clk(clk),
        .pwmldce(pwmldce),
        .wrtdata(wrtdata),
        .pwmval(pwmval)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pwmldce <= 1;
            wrtdata <= 8'h00;
            @(posedge clk);
            #1;
            pwmldce <= 0;
            wrtdata <= 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading value 0xA5", test_num);
            reset_dut();

            wrtdata <= 8'hA5;
            pwmldce <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing hold behavior (pwmldce=0)", test_num);
            reset_dut();

            wrtdata <= 8'hFF;
            pwmldce <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading boundary value 0xFF", test_num);
            reset_dut();

            wrtdata <= 8'hFF;
            pwmldce <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data changes while load enable is low", test_num);
            reset_dut();


            wrtdata <= 8'h55;
            pwmldce <= 1;
            @(posedge clk);
            #1;


            pwmldce <= 0;
            wrtdata <= 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple consecutive updates", test_num);
            reset_dut();


            wrtdata <= 8'h11;
            pwmldce <= 1;
            @(posedge clk);
            #1;


            wrtdata <= 8'h22;
            pwmldce <= 1;
            @(posedge clk);
            #1;


            wrtdata <= 8'h33;
            pwmldce <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data change between clock edges", test_num);
            reset_dut();

            pwmldce <= 1;
            wrtdata <= 8'hCC;
            @(posedge clk);
            #1;

            wrtdata <= 8'hDD;
            #2;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pwmregister Testbench");
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
        input [7:0] expected_pwmval;
        begin
            if (expected_pwmval === (expected_pwmval ^ pwmval ^ expected_pwmval)) begin
                $display("PASS");
                $display("  Outputs: pwmval=%h",
                         pwmval);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwmval=%h",
                         expected_pwmval);
                $display("  Got:      pwmval=%h",
                         pwmval);
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
        $dumpvars(0,clk, pwmldce, wrtdata, pwmval);
    end

endmodule
